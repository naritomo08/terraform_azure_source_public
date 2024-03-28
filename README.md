# terraform_azure_source_public

## 立ち上げ概要

Azureにて2つのサブネットを作成し、それぞれのサブネットでWindows/Linuxを立ち上げ、片方のサブネットのVMにパブリックIPを割り当てる。

## 前提

以下のページなどを参考に、terraform稼働環境を作成し、OCIでの適当なリソースが作成できる状態にあること。

[Terraformをdocker環境で立ち上げてみる。](https://qiita.com/naritomo08/items/7e5a9d1b7eaf18dc0060)

Dockerを使用しない場合、以下のコマンドを利用できている状態になっていること。

```bash
aws

brew
*Terraform導入時に必要

tfenv
*terraform稼働コンテナを利用しない場合は必要
```

### (コンテナ利用しない場合)指定バージョン(1.５．７)のterraformを導入する。

```bash
tfenv install
```

## terraformソースファイル入手

terraformを動かすフォルダ内にて、以下コマンドを稼働する。

```bash
git clone https://github.com/naritomo08/terraform_azure_source_public.git
cd terraform_oci_source_public
rm -rf .git
```

## 作成(tfstate保存ストレージ作成)

tfstateフォルダ内へ入り、リソース作成を実施する。

```bash
cd tfstate

terraform init
terraform plan
terraform apply
cd ..
```

作成実施したときに出てくるtfstate_nameの値を控える。

## ストレージパス設定

```bash
az login
export ARM_ACCESS_KEY=$(az storage account keys list --resource-group tfstate --acc
ount-name <ストレージアカウント名> --query '[0].value' -o tsv)
→新しくターミナルを立ち上げるたびに設定すること。
```

## 作成（基本ネットワーク作成）

networkフォルダ内へ入り、リソース作成を実施する。

```bash
cd network

vi backend.tf

<ストレージ名>を保存ストレージ作成で控えた名前をいれる。

terraform init
terraform plan
terraform apply
cd ..
```

## 作成（PublicVM(Windows/Linux)作成）

publicvmフォルダ内へ入り、リソース作成を実施する。

```bash
cd publicvm

vi backend.tf

<ストレージ名>を保存ストレージ作成で控えた名前をいれる。

terraform init
terraform plan
terraform apply
cd ..
```

applyコマンド実施後に出てくるIPを控え、
"vmXX.tf"内の以下のパラメータを使用してRDPログインする。
admin_username
admin_password

## 作成（PrivateVM(Windows/Linux)作成）

publicvmフォルダ内へ入り、リソース作成を実施する。

```bash
cd privatevm

vi backend.tf

<ストレージ名>を保存ストレージ作成で控えた名前をいれる。

terraform init
terraform plan
terraform apply
cd ..
```

applyコマンド実施後に出てくるIPを控え、
"vmXX.tf"内の以下のパラメータを使用してRDPログインする。
admin_username
admin_password

## 削除方法

作成とは逆の手順で削除する。

以下のコマンドで削除可能

一度作成できれば最後のコマンドのみでよい。
```bash
terraform destroy
```

## 一部リソースのみの削除手順

```bash
terraform state list
→リソース確認
terraform apply --target="リソース名"
→再作成対象のリソース指定
terraform destroy --target="リソース名"
→削除対象のリソース指定
```
