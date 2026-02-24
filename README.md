# azure-bicep-cost-guard-patterns

Zenn 記事「[Azureのコスト爆発を防ぐBicepパターン集](https://zenn.dev/yotan/articles/bicep-cost-guard-patterns)」の動作確認済みサンプルコードです。

## パターン一覧

| ファイル | 内容 |
|---------|------|
| `budget.bicep` | パターン1: Budget アラート（80%/100%/予測120%）|
| `vm-env-sku.bicep` | パターン2: 環境別 VM SKU 切り替え（dev/stg/prod）|
| `auto-shutdown.bicep` | パターン3: VM Auto-shutdown（JST 22:00）|
| `storage-lifecycle.bicep` | パターン4: ストレージライフサイクルルール |
| `tags.bicep` | パターン5: タグ強制（Owner/Project/Environment/CostCenter）|
| `bastion-dev.bicep` | パターン6: Bastion Developer SKU（dev環境無料）|

## 使い方

各 `.bicepparam` ファイルをコピーして値を書き換え、以下のコマンドでデプロイします。

```bash
RG="your-resource-group"
az group create -n $RG -l japaneast
az deployment group create -g $RG --template-file <template>.bicep --parameters <params>.bicepparam
```

## 動作確認環境

- Bicep CLI: 最新版（`az bicep install`）
- Azure CLI: 2.x
- デプロイリージョン: Japan East

## 注意事項

- `budget.bicep`: `startDate` は当月以降を指定すること
- `tags.bicep`: `utcNow()` を CI で使う場合は `--parameters deployedAt=$(date +%F)` で外部注入を推奨
- `vm-env-sku.bicep`: `Standard_D4s_v5` は従量課金サブスクでクォータ 0 の場合あり（`Standard_B4ms` 等に変更を）
- `bastion-dev.bicep`: Developer SKU は同時接続セッション数が 1 に制限されます
