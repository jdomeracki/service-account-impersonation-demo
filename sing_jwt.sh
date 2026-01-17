# Check if PROJECT_ID is provided
if [ -z "$PROJECT_ID" ]; then
  echo "Error: PROJECT_ID environment variable is required"
  echo "Usage: PROJECT_ID=your-project-id ./sing_jwt.sh"
  exit 1
fi

SECOPS_AUTH_SA_EMAIL="secops-auth@${PROJECT_ID}.iam.gserviceaccount.com"
GKE_INIT_PYTHON_SA_EMAIL="gke-init-python@${PROJECT_ID}.iam.gserviceaccount.com"

TMP_DIR=$(mktemp -d /tmp/sa_signed_jwt.XXXXX)
trap "rm -rf ${TMP_DIR}" EXIT
JWT_FILE="${TMP_DIR}/jwt-claim-set.json"
SIGNED_JWT_FILE="${TMP_DIR}/output.jwt"

IAT=$(date '+%s')
EXP=$((IAT+3600))

# Use PROJECT_ID for the audience field (convert to uppercase for consistency)
AUD=$(echo "$PROJECT_ID" | tr '[:lower:]' '[:upper:]')

cat <<EOF > $JWT_FILE
{
  "aud": "$AUD",
  "email": "$SECOPS_AUTH_SA_EMAIL",
  "exp": $EXP,
  "family_name": "Demo",
  "given_name": "Live",
  "iat": $IAT,
  "idp_groups": "Chronicle SOAR Admin,$SECOPS_AUTH_SA_EMAIL",
  "iss": "$SECOPS_AUTH_SA_EMAIL",
  "scope": "https://www.googleapis.com/auth/iam",
  "sub": "$SECOPS_AUTH_SA_EMAIL"
}
EOF
GKE_INIT_PYTHON_SA_TOKEN=$(gcloud auth print-access-token --impersonate-service-account=$GKE_INIT_PYTHON_SA_EMAIL)

export CLOUDSDK_AUTH_ACCESS_TOKEN=$GKE_INIT_PYTHON_SA_TOKEN

gcloud iam service-accounts sign-jwt --iam-account=$SECOPS_AUTH_SA_EMAIL $JWT_FILE $SIGNED_JWT_FILE

cat $SIGNED_JWT_FILE | jq -R 'split(".") | .[1] | @base64d | fromjson'
