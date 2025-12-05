// This is an enhanced enum

enum MyNavigatorRoute {
  home("/", "home"),
  stats("stats", "stats"),
  day("day", "day"),
  profile("profile", "profile"),
  users("users", "users"),
  theme("/theme", "theme"),
  companies("companies", "companies"),
  datacenters("datacenters", "datacenters"),
  gpus("gpus", "gpus"),
  gpuClusters("gpu_clusters", "gpu_clusters"),
  market("market", "market"),
  splash("/splash", "splash"),
  dataEntry("data_entry", "data_entry"),
  dataEntryTop("/data_entry_top", "data_entry_top"),
  consumptionEntry("/consumption_entry", "consumption_entry"),
  signIn("/sign_in", "sign_in");

  const MyNavigatorRoute(this.path, this.name);

  final String path;

  final String name;
}
