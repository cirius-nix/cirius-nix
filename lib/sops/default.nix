{ ... }:
{
  sops = {
    isSecretFileExists = secretPath: builtins.pathExists ../../secrets/${secretPath};
  };
}
