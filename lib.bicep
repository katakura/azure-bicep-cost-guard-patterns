@export()
type NsgRule = {
  name: string
  priority: int
  destinationPortRange: string
}

@export()
@description('環境名からVMのSKUを解決する。skuMapに存在しない環境名を渡すとデプロイ時にキー参照エラーになる')
func resolveVmSku(env string, skuMap object) string => skuMap[env]

@export()
@description('環境名からディスクの種類を決定する（prodのみPremium_LRS）')
func resolveDiskType(env string) string => env == 'prod' ? 'Premium_LRS' : 'Standard_LRS'

@export()
@description('NSGの許可ルールを共通の形で組み立てる')
func buildAllowRule(name string, priority int, port string) NsgRule => {
  name: name
  priority: priority
  destinationPortRange: port
}
