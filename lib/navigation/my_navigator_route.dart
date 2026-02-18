// This is an enhanced enum

enum MyNavigatorRoute {
  home("/", "home"),
  stats("stats", "stats"),
  day("day", "day"),
  profile("profile", "profile"),
  users("users", "users"),
  transactions("transactions", "transactions"),
  data("data", "data"),
  admin("admin", "admin"),
  listing("listing", "listing"),
  corpAdmin("corp_admin", "corp_admin"),
  corpAdminOnboarding("corp_admin_onboarding", "corp_admin_onboarding"),
  corpAdminUsers("corp_admin_users", "corp_admin_users"),
  corpAdminListings("corp_admin_listings", "corp_admin_listings"),
  corpAdminGpuClusters("corp_admin_gpu_clusters", "corp_admin_gpu_clusters"),
  corpAdminDataCenters("corp_admin_data_centers", "corp_admin_data_centers"),
  corpAdminCompany("corp_admin_company", "corp_admin_company"),
  corpUserAccept("/corporate_user_accept", "corporate_user_accept"),
  onboarding("onboarding", "onboarding"),
  theme("/theme", "theme"),
  companies("companies", "companies"),
  adminCompanies("admin_companies", "admin_companies"),
  datacenters("datacenters", "datacenters"),
  gpus("gpus", "gpus"),
  gpuClusters("gpu_clusters", "gpu_clusters"),
  market("market", "market"),
  widgets("/widgets", "widgets"),
  splash("/splash", "splash"),
  dataEntry("data_entry", "data_entry"),
  dataEntryTop("/data_entry_top", "data_entry_top"),
  consumptionEntry("/consumption_entry", "consumption_entry"),
  signIn("/sign_in", "sign_in");

  const MyNavigatorRoute(this.path, this.name);

  final String path;

  final String name;
}
