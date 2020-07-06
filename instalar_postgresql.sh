function ubuntu_focal {
	sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list';
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -;
	sudo apt-get update;
	sudo apt-get install postgresql;
}

function ubuntu_bionic {
	sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt bionic-pgdg main" > /etc/apt/sources.list.d/pgdg.list';
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -;
	sudo apt-get update;
	sudo apt-get install postgresql;
}

function ubuntu_xenial {
	sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list';
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -;
	sudo apt-get update;
	sudo apt-get install postgresql;
}

function escolher_distro {
	escolha="0";
	while [ "$escolha" != "1" ] || [ "$escolha" != "2" ] || [ "$escolha" != "3" ];
	do
		echo "";
		echo "Fazer instalação característica do:";
		echo "";
		echo "1 - Ubuntu Focal Fossa (20.04)";
		echo "2 - Ubuntu Bionic Beaver (18.04)";
		echo "3 - Ubuntu Xenial Xerus (16.04)";
		echo "";
		read -p "Digite o número da opção desejada: " escolha;
		if [ "$escolha" == "1" ];
		then
			ubuntu_focal;
		elif [ "$escolha" == "2" ];
		then
			ubuntu_bionic;
		elif [ "$escolha" == "3" ];
		then
			ubuntu_xenial;
		else
			echo "";
			echo "Opção indisponível!";
		fi
	done
}

function verifica_versao {

	codinome=$(grep ^"VERSION_CODENAME=" /etc/os-release | sed 's/^VERSION_CODENAME=//' | sed 's/"//' | sed 's/"//');

	if [ "$codinome" == "focal" ];
	then
		ubuntu_focal;
	elif [ "$codinome" == "bionic" ];
	then
		ubuntu_bionic;
	elif [ "$codinome" == "xenial" ];
	then
		ubuntu_xenial;
	else
		echo "";
		echo "Sua distro não foi reconhecida como Ubuntu Focal Fossa (20.04), Ubuntu Bionic Beaver (18.04) ou como Ubuntu Xenial Xerus (16.04).";
		echo "A instalação pode não funcionar nesta versão!";
		read -p "Deseja continuar a instalação (por sua conta em risco)? [s/N] " escolha;
		if [ "$escolha" == "s" ] || [ "$escolha" == "S" ];
		then
			escolher_distro;
		else
			echo "Script abortado!";
		fi
	fi
}

function verifica_distribuicao {

	distro=$(grep ^"ID=" /etc/os-release | sed 's/^ID=//' | sed 's/"//' | sed 's/"//');

	if [ "$distro" == "ubuntu" ];
	then
		verifica_versao;
	else
		echo "";
		echo "Sua distribuição Linux não foi reconhecida como Ubuntu.";
		echo "O script de instalação pode não funcionar neste sistema!";
		read -p "Deseja continuar a instalação por sua conta em risco? [s/N] " escolha;
		if [ "$escolha" == "s" ] || [ "$escolha" == "S" ];
		then
			escolher_distro;
		else
			echo "Script abortado!";
		fi
	fi
}

clear;
echo "Script de instalação do PostgreSQL para Ubuntu LTS.";
echo "Isso vai modificar seu sistema!";
read -p "Continuar? [S/n] " escolha;
if [ "$escolha" == "s" ] || [ "$escolha" == "S" ];
then
	verifica_distribuicao;
else
	echo "Script abortado!";
fi
