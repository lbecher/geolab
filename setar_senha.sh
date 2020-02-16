read -p "Nova senha: " senha;
read -p "Confirme a nova senha: " senha_c;
if [ "$senha" == "$senha_c" ]
then
usermod -p $(openssl passwd -1 $senha) postgres;
su -c "psql -c \"ALTER USER postgres WITH PASSWORD '${senha}'\";" -s /bin/sh postgres;
else
echo "As senhas não combinam!";
fi
