#!/bin/bash

# Ref: https://docs.aws.amazon.com/zh_cn/kms/latest/developerguide/importing-keys-encrypt-key-material.html 

openssl rand -out PlaintextKeyMaterial.bin 32

openssl rsautl -encrypt \
                 -in PlaintextKeyMaterial.bin \
                 -oaep \
                 -inkey wrappingKey_0e40a8a3-b33e-46ee-aea3-6a77c8f8f65c_0212014400 \
                 -keyform DER \
                 -pubin \
                 -out EncryptedKeyMaterial.bin
