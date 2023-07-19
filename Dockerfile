FROM node:18.16-bullseye

ADD . /opt/evm-placeholder-verification

WORKDIR /opt/evm-placeholder-verification

RUN npm i
RUN npx hardhat compile