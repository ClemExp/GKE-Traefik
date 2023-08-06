When generating certificates via Lets encrypt, by default these will be generated with .cer & .key (private key). Commands below are for private keys in elliptic curve format.

For import into GCP they need to be converted into .pem format.

You can do so via:
openssl x509 -in fullchain.cer -outform pem -out fullchain.pem
openssl ec -in privKey.key -outform pem -out privKey.pem
