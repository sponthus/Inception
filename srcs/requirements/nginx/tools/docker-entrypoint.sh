# Generating a self signed certificate
# -x509 = self signed 
# -out = private key
# -keyout = certificate
# -subj = mandatory, subject describes ID that emits certificate
#  CN (Common Name) is mandatory because checked by the client when establishing HTTPS
#  O (Operation) name of structure or entity
#  ST (state)
#  C (country)
# -addext = adds extensions to the certificate, mandatory for SAN to avoid security warnings
#  SAN = Subject Alternative Names, other addresses covered by the certificate
#  ex: hello.com has www.hello.com SAN (DNS:)
#  DNS: = domain name, IP: = IP, email:, URI:, otherName: ... 
# -nodes = pas de passphrase
openssl req -newkey rsa:4096 \
	-x509 \
	-subj "/C=FR/ST=FR/O=42/CN=$DOMAIN_NAME" \
	-addext "subjectAltNames=DNS:$DOMAIN_NAME" \
	-out /etc/nginx/key/sponthus.crt \
	-keyout /etc/nginx/key/sponthus.key;
echo "Self-signed certificate generated"


