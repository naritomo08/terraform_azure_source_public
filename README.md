# terraform_azure_source_public

## 立ち上げ概要

Azureの2つのVNCにて2つのプライベートSubnetを作成しており、

そのうち2つのサブネットで仮想マシンを立ち上げ。

仮想マシンからはNAT Gatewayで外部へ接続可能。

VCN1からはFLBが設置されており、別途証明書作成したSSLで外部からのWebサイトアクセス可能。

家の環境からはVPNルータCisco891FJを使用し、仮想マシンアクセス可能。

構築時はある程度自動化できるようFLB,VPN以外はI2C(Terraform)を使用し建てています。

また、外部へのメール送信は外部のメールシステムを利用しています。

本構成でOCIのみで1日3.6円（１ヶ月約108円）ですみます。

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
git clone https://github.com/naritomo08/terraform_oci_source_public.git
cd terraform_oci_source_public
rm -rf .git
```

## 作成（基本ネットワーク、PublicCompute(Linux)作成）

defaultフォルダ内へ入り、リソース作成を実施する。

作成後Computeに対しSSHを使用してOCIから接続できること。

## 作成（PublicCompute(Windows)作成）

computeフォルダにあるファイルをdefaultフォルダに入れ作成コマンドで稼働する。

RDPを使用してパブリックIP,ユーザ：opc,パスワード：OCIコンソール上の初期パスワードを指定して接続する。

## 作成（mysql作成）

mysqlフォルダにあるファイルをdefaultフォルダに入れ作成コマンドで稼働する。

作成したComputeを使用し接続する。

## 作成（oracle作成）

oracleフォルダにあるファイルをdefaultフォルダに入れ作成コマンドで稼働する。

作成したComputeを使用し接続する。

### 作成コマンド

以下のコマンドで作成可能

一度作成できれば最後のコマンドのみでよい。
```bash
terraform init
terraform plan
terraform apply
→　yesを入力する。
```

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


