> ## Link dos slides: [Começando em Docker](https://github.com/PHPRio/CFP/issues/156)

<br />

# Criando uma Dockerfile

## FROM

Começamos definindo a partir de qual ambiente começamos a desenvolver, podemos escolher um ambiente 100% limpo ou podemos pegar uma image com ferramentes pré-configuradas. Para facilitar o exemplo dessa apresentação, resolvi pegar a image "php:8.1"

```dockerfile
FROM php:8.1
```

## WORKDIR

Definindo o lugar onde iremos acessar dentro do container, temos mais controle sobre como nossas configurações vão afetar o comportamento do container. Definindo que trabalharemos na pasta ```/home``` podemos garantir que não iremos sobrescrever nada.

```dockerfile
WORKDIR /home
```

## COPY

Tendo configurado já o ambiente inicial e a pasta onde iremos trabalhar, podemos mover nossa aplicação pra dentro do container. os paramêtros do ```COPY``` definem o que vamos mover de fora para onde vamos mover dentro. Aqui movemos todo o conteúdo da pasta app fora do container e movemos para ```"."``` que faz referencia para o ```workdir``` atual.

```dockerfile
COPY app .
```

## RUN

Caso seja necessário executar algum comando de configuração para instalar alguma dependencia ou alterar o conteúdo do container de algum jeito, podemos rodar usar o ```RUN``` para resolver isso no processo de building da imagem.

```dockerfile
RUN echo "phpinfo();" >> index.php
```

## CMD

Com a aplicação pronta num ambiente já configurado, basta especificarmos qual o comando será necessario para rodar quando subir um container. Esse comando será executado sempre que um novo container for iniciado.

```dockerfile
CMD php -S 0.0.0.0:8000
```

# Subindo a aplicação

## docker build

Tendo um dockerfile podemos por nossa aplicação em uma camada acima da imagem base que escolhemos na dockerfile, nesse caso ```php:8.1```.

```bash
$ docker build -t app .
```

## docker run

A imagem gerada pelo build pode ser executada como container usando o comando ```docker run```, assim um ambiente será executado usando a imagem que criamos como modelo.

```
$ docker run app
```

## port binding

Um ponto importante do docker é que todo container é completamente isolado por padrão, sendo separado em uma rede própria pro docker. Para expor a porta em que rodamos nosso programa PHP, usamos a flag "-p {porta interna}:{porta externa}".

```
$ docker run -p 8000:8000 app
```

## volumes binding

Uma flag muito útil do docker é associar uma pasta dentro do container com uma fora, fazendo isso o conteúdo dessa pasta interna reflete ao conteúdo da pasta externa. "-v {path absoluto externo}:{path interno}"

```
$ docker run -v $(pwd)/app:/home app
```

## executando um ambiente de desenvolvimento

Juntando tudo isso podemos montar um ambiente de desenvolvimento com qualquer linguagem/ferramenta.

[Exemplo de ambiente de dev manual](/dev.sh) usando [essa dockerfile](/dockerfile)

# Docker compose

Uma automação muito válida de se usar para subir containers docker é deixar tudo configurado usando um arquivo docker-compose.yml

Traduzindo o [Exemplo manual](/dev.sh) para
a [versão com docker compose](/docker-compose.yml):

## services

Cada serviço definido no arquivo vai ser o equivalente a um tipo de container diferente que vai subir. Aqui definimos apenas um container chamado "web" para rodar a aplicação

```yml
services:
    web:
```

## definindo a base do serviço

Para deixarmos explicito que precisamos dar build para criar a imagem base desse serviço, definimos a propriedade "build" como o path do dockerfile.

```yml
services:
    web:
        build: .
```

## definindo paramêtros do container

Usando os paramêtros de port e volumes, podemos definir tambem as portas que devem ser expostas e volumes que devem ser associados. Os paramêtros seguem o mesmo padrão que as flags originais do docker.

```yml
services:
    web:
        build: .
        ports:
            - "8000:8000"
        volumes:
            - ./app:/home
```
