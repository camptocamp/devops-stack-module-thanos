# Changelog

## [7.0.1](https://github.com/camptocamp/devops-stack-module-thanos/compare/v7.0.0...v7.0.1) (2024-10-11)


### Bug Fixes

* grafana panels uses angular deprecated plugin ([#90](https://github.com/camptocamp/devops-stack-module-thanos/issues/90)) ([bf7302f](https://github.com/camptocamp/devops-stack-module-thanos/commit/bf7302f8dd3f7b5b4655f9754213e3f59f047695))

## [7.0.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v6.0.0...v7.0.0) (2024-10-09)


### ⚠ BREAKING CHANGES

* point the Argo CD provider to the new repository ([#88](https://github.com/camptocamp/devops-stack-module-thanos/issues/88))

### Features

* point the Argo CD provider to the new repository ([#88](https://github.com/camptocamp/devops-stack-module-thanos/issues/88)) ([503c776](https://github.com/camptocamp/devops-stack-module-thanos/commit/503c77666b8d53460c747d1d7ca8256ea96d5423))

### Migrate provider source `oboukili` -> `argoproj-labs`

We've tested the procedure found [here](https://github.com/argoproj-labs/terraform-provider-argocd?tab=readme-ov-file#migrate-provider-source-oboukili---argoproj-labs) and we think the order of the steps is not exactly right. This is the procedure we recommend (**note that this should be run manually on your machine and not on a CI/CD workflow**):

1. First, make sure you are already using version 6.2.0 of the `oboukili/argocd` provider.

1. Then, check which modules you have that are using the `oboukili/argocd` provider.

```shell
$ terraform providers

Providers required by configuration:
.
├── provider[registry.terraform.io/hashicorp/helm] 2.15.0
├── (...)
└── provider[registry.terraform.io/oboukili/argocd] 6.2.0

Providers required by state:

    (...)

    provider[registry.terraform.io/oboukili/argocd]

    provider[registry.terraform.io/hashicorp/helm]
```

3. Afterwards, proceed to point **ALL*  the DevOps Stack modules to the versions that have changed the source on their respective requirements. In case you have other personal modules that also declare `oboukili/argocd` as a requirement, you will also need to update them.

4. Also update the required providers on your root module. If you've followed our examples, you should find that configuration on the `terraform.tf` file in the root folder.

5. Execute the migration  via `terraform state replace-provider`:

```bash
$ terraform state replace-provider registry.terraform.io/oboukili/argocd registry.terraform.io/argoproj-labs/argocd
Terraform will perform the following actions:

  ~ Updating provider:
    - registry.terraform.io/oboukili/argocd
    + registry.terraform.io/argoproj-labs/argocd

Changing 13 resources:

  module.argocd_bootstrap.argocd_project.devops_stack_applications
  module.secrets.module.secrets.argocd_application.this
  module.metrics-server.argocd_application.this
  module.efs.argocd_application.this
  module.loki-stack.module.loki-stack.argocd_application.this
  module.thanos.module.thanos.argocd_application.this
  module.cert-manager.module.cert-manager.argocd_application.this
  module.kube-prometheus-stack.module.kube-prometheus-stack.argocd_application.this
  module.argocd.argocd_application.this
  module.traefik.module.traefik.module.traefik.argocd_application.this
  module.ebs.argocd_application.this
  module.helloworld_apps.argocd_application.this
  module.helloworld_apps.argocd_project.this

Do you want to make these changes?
Only 'yes' will be accepted to continue.

Enter a value: yes

Successfully replaced provider for 13 resources.
```

6. Perform a `terraform init -upgrade` to upgrade your local `.terraform` folder.

7. Run a `terraform plan` or `terraform apply` and you should see that everything is OK and that no changes are necessary. 

## [6.0.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v5.0.0...v6.0.0) (2024-08-14)


### ⚠ BREAKING CHANGES

* **sks:** remove the cluster_id variable

### Features

*  **sks:** remove the cluster_id variable ([6d7b628](https://github.com/camptocamp/devops-stack-module-thanos/commit/6d7b6280c67373d65f04f069b35a58f64174dd3a))

## [5.0.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v4.1.0...v5.0.0) (2024-04-23)


### ⚠ BREAKING CHANGES

* **eks:** add option to create IAM role for the metrics storage
  * This is a breaking change because the attributes of the `metrics_storage` variable has changed. Please check the README.adoc to see the differences.

### Features

* **eks:** add option to create IAM role for the metrics storage ([90f9f54](https://github.com/camptocamp/devops-stack-module-thanos/commit/90f9f541e80a9cd1a5b59720c541d117501fa7d4))

## [4.1.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v4.0.0...v4.1.0) (2024-04-16)


### Features

* add variable to set resources with default values ([ff2d2ba](https://github.com/camptocamp/devops-stack-module-thanos/commit/ff2d2bac07115d0ca547dcf3cffabf7d1de57060))
* upgrade OAuth Proxy image version ([5072bbc](https://github.com/camptocamp/devops-stack-module-thanos/commit/5072bbc0f90f32d283111f358704e1b8f8d806ee))

## [4.0.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v3.3.0...v4.0.0) (2024-03-01)


### ⚠ BREAKING CHANGES

* **chart:** major update of dependencies on thanos chart

  The breaking change on the Thanos chart is the activation of the NetworkPolicies by default and now the configuration is per component instead of globally.

  See official information [here](https://github.com/bitnami/charts/blob/main/bitnami/thanos/README.md#to-1300).

  On my tests, I found out that the official NetworkPolicies were blocking the access through Traefik. Since the work of activating the NetworkPolicies on the DevOps Stack modules is already on the horizon, I decided to deactivate them and keep the current behaviour of the module for the time being.

* remove specific var and use the ServiceMonitor boolean

  The variable `enable_monitoring_dashboard` introduced on the last release was removed, because on the other modules we've decided to simply deploy the dashboards automatically as long as the `serviceMonitor` for the metrics is activated. So we've reverted this addition to keep the behavior of the modules consistent.


### Features

* **chart:** major update of dependencies on thanos chart ([bbd5e67](https://github.com/camptocamp/devops-stack-module-thanos/commit/bbd5e67d68d83528d6f6eb33d2b5eb2e1c5ed7f5))


### Bug Fixes

* change backend port that was changed in the original chart ([0ac7aab](https://github.com/camptocamp/devops-stack-module-thanos/commit/0ac7aabf0a32d562844dadbbfabd21de925d7a3b))
* disable networkPolicy on all components ([5a84b3a](https://github.com/camptocamp/devops-stack-module-thanos/commit/5a84b3a548841cfb87f2bb23e2333862c4e3198f))
* remove legacy ingress annotations ([f3eee6a](https://github.com/camptocamp/devops-stack-module-thanos/commit/f3eee6ae543a6889b9e5dcd5fd509b4e3f0caa7e))
* remove specific var and use the ServiceMonitor boolean ([de3db09](https://github.com/camptocamp/devops-stack-module-thanos/commit/de3db094082ed39ae0cce9c96e9bb1c6b891503d))

## [3.3.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v3.2.0...v3.3.0) (2024-02-23)


### Features

* add a subdomain variable ([46fbe8d](https://github.com/camptocamp/devops-stack-module-thanos/commit/46fbe8d5625ed697b335f7fbec5de52b4441bfbc))


### Bug Fixes

* make subdomain variable non-nullable ([4ace0e5](https://github.com/camptocamp/devops-stack-module-thanos/commit/4ace0e53353d01b5896bb0df97fc07a9cb623dcc))
* remove annotation for the redirection middleware ([2bef626](https://github.com/camptocamp/devops-stack-module-thanos/commit/2bef6260dc17f4363f2be4d525c64fed428d659a))

## [3.2.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v3.1.0...v3.2.0) (2024-02-09)


### Features

* add Grafana dashboards and alerts to monitor Thanos ([4c55520](https://github.com/camptocamp/devops-stack-module-thanos/commit/4c55520b9b374c1955d6fee69e01b3b18406f892))

## [3.1.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v3.0.1...v3.1.0) (2024-02-07)


### Features

* configure Thanos caching ([#64](https://github.com/camptocamp/devops-stack-module-thanos/issues/64)) ([131e6e4](https://github.com/camptocamp/devops-stack-module-thanos/commit/131e6e4868edefbc80fa20491aba26fa0c464875))

## [3.0.1](https://github.com/camptocamp/devops-stack-module-thanos/compare/v3.0.0...v3.0.1) (2024-01-22)


### Bug Fixes

* **aks:** add dependencies to fix reading of storage account ([#68](https://github.com/camptocamp/devops-stack-module-thanos/issues/68)) ([128b0b8](https://github.com/camptocamp/devops-stack-module-thanos/commit/128b0b839790c89cdcdde4d65c5a6b9812e1a34e))

## [3.0.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v2.7.0...v3.0.0) (2024-01-18)


### ⚠ BREAKING CHANGES

* remove the ArgoCD namespace variable
* remove the namespace variable
* hardcode the release name to remove the destination cluster

### Features

* **aks:** add support to use workload identity for storage authentication ([ffc3dce](https://github.com/camptocamp/devops-stack-module-thanos/commit/ffc3dcecf9079063f96de61dfac34bac71d37a0e))
* **chart:** minor update of dependencies on thanos chart ([#63](https://github.com/camptocamp/devops-stack-module-thanos/issues/63)) ([603dc15](https://github.com/camptocamp/devops-stack-module-thanos/commit/603dc153399276f59b8d91d0760613ca85da4c26))


### Bug Fixes

* change the default cluster issuer ([adf5067](https://github.com/camptocamp/devops-stack-module-thanos/commit/adf5067477c8a16be9dbd2e90d1157bb2235d970))
* hardcode the release name to remove the destination cluster ([811f702](https://github.com/camptocamp/devops-stack-module-thanos/commit/811f702fc1722d83b5ae69a38caf2d62354b4b3d))
* remove the ArgoCD namespace variable ([61771f6](https://github.com/camptocamp/devops-stack-module-thanos/commit/61771f6af29ab627e3137f45fc982c5891b4717d))
* remove the namespace variable ([b242859](https://github.com/camptocamp/devops-stack-module-thanos/commit/b242859cbb0fa6d9c1a25958dd074335290f3d64))

## [2.7.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v2.6.0...v2.7.0) (2023-11-03)


### Features

* **chart:** patch update of dependencies on thanos chart ([#55](https://github.com/camptocamp/devops-stack-module-thanos/issues/55)) ([c076227](https://github.com/camptocamp/devops-stack-module-thanos/commit/c076227e9f04cad15f8b88fa459dc27518cf5736))

## [2.6.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v2.5.0...v2.6.0) (2023-10-19)


### Features

* add standard variables and variable to add labels to Argo CD app ([7db831d](https://github.com/camptocamp/devops-stack-module-thanos/commit/7db831da02d6e3d193cfb0b72a561f203abfb56a))
* add variables to set AppProject and destination cluster ([1822dcf](https://github.com/camptocamp/devops-stack-module-thanos/commit/1822dcf2f8dd62875048cdf6976da601b972af4a))
* update OAuth2-Proxy image to v7.5.0 ([88b6d99](https://github.com/camptocamp/devops-stack-module-thanos/commit/88b6d99039b7720348c9b8febed214b054071420))

## [2.5.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v2.4.0...v2.5.0) (2023-09-19)


### Features

* **thanos:** add deep_merge_append_list variable ([#56](https://github.com/camptocamp/devops-stack-module-thanos/issues/56)) ([7b553bc](https://github.com/camptocamp/devops-stack-module-thanos/commit/7b553bcf2e4826ef025d8f4dec70069fb3a8241e))

## [2.4.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v2.3.0...v2.4.0) (2023-09-08)


### Features

* **chart:** patch update of dependencies on thanos chart ([#53](https://github.com/camptocamp/devops-stack-module-thanos/issues/53)) ([e4b3487](https://github.com/camptocamp/devops-stack-module-thanos/commit/e4b3487b0f5f35b69e88479b8befcee9f71aeb47))

## [2.3.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v2.2.0...v2.3.0) (2023-09-07)


### Features

* **chart:** minor update of dependencies on thanos chart ([#50](https://github.com/camptocamp/devops-stack-module-thanos/issues/50)) ([87fbc5f](https://github.com/camptocamp/devops-stack-module-thanos/commit/87fbc5f96774448fe048914b612bef300628eb3b))

## [2.2.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v2.1.0...v2.2.0) (2023-08-28)


### Features

* **chart:** patch update of dependencies on thanos chart ([#48](https://github.com/camptocamp/devops-stack-module-thanos/issues/48)) ([1a03430](https://github.com/camptocamp/devops-stack-module-thanos/commit/1a03430e0e611d70b0479ced8c92e61d73e7ae88))

## [2.1.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v2.0.1...v2.1.0) (2023-08-11)


### Features

* **chart:** minor update of dependencies on thanos chart ([#45](https://github.com/camptocamp/devops-stack-module-thanos/issues/45)) ([d816b06](https://github.com/camptocamp/devops-stack-module-thanos/commit/d816b06befd79db2032a07830e48a6b14d9a38ca))

## [2.0.1](https://github.com/camptocamp/devops-stack-module-thanos/compare/v2.0.0...v2.0.1) (2023-08-09)


### Bug Fixes

* readd support to deactivate auto-sync which was broken by [#41](https://github.com/camptocamp/devops-stack-module-thanos/issues/41) ([6f989bc](https://github.com/camptocamp/devops-stack-module-thanos/commit/6f989bc8a2e5a3078656c47aa565161f249ea6b2))

## [2.0.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v1.1.0...v2.0.0) (2023-07-11)


### ⚠ BREAKING CHANGES

* add support to oboukili/argocd >= v5 ([#41](https://github.com/camptocamp/devops-stack-module-thanos/issues/41))

### Features

* add support to oboukili/argocd &gt;= v5 ([#41](https://github.com/camptocamp/devops-stack-module-thanos/issues/41)) ([2622962](https://github.com/camptocamp/devops-stack-module-thanos/commit/26229620933c2b36ab3d7c4dd72616ac88dcc460))

## [1.1.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v1.0.1...v1.1.0) (2023-06-28)


### Features

* add first version of the SKS variant ([9574559](https://github.com/camptocamp/devops-stack-module-thanos/commit/9574559061bb8f2e81d9dffb8a01be7524bfdc3f))
* upgrade chart version of the OAuth2-Proxy ([3eaa966](https://github.com/camptocamp/devops-stack-module-thanos/commit/3eaa9668b5703bf634213d535e7975dc677fdba0))
* upgrade Thanos chart to v12.6.3 ([f16b6a1](https://github.com/camptocamp/devops-stack-module-thanos/commit/f16b6a1875ad8969aa9a8db7f149623be4a16c29))

## [1.0.1](https://github.com/camptocamp/devops-stack-module-thanos/compare/v1.0.0...v1.0.1) (2023-06-05)


### Bug Fixes

* add default argocd_namespace ([#37](https://github.com/camptocamp/devops-stack-module-thanos/issues/37)) ([ef1ce92](https://github.com/camptocamp/devops-stack-module-thanos/commit/ef1ce929546dc702b95ca4a1ab23be3030c60cbd))

## [1.0.0](https://github.com/camptocamp/devops-stack-module-thanos/compare/v1.0.0-alpha.8...v1.0.0) (2023-04-06)


### ⚠ BREAKING CHANGES

* **azure:** use managed identity to access object storage ([#33](https://github.com/camptocamp/devops-stack-module-thanos/issues/33))

### Features

* **azure:** use managed identity to access object storage ([#33](https://github.com/camptocamp/devops-stack-module-thanos/issues/33)) ([6efba02](https://github.com/camptocamp/devops-stack-module-thanos/commit/6efba0296746870dad1518937673aa2afaebb406))

## [1.0.0-alpha.8](https://github.com/camptocamp/devops-stack-module-thanos/compare/v1.0.0-alpha.7...v1.0.0-alpha.8) (2023-01-30)


### Features

* **helm:** bump chart to v12 ([#26](https://github.com/camptocamp/devops-stack-module-thanos/issues/26)) ([ad51036](https://github.com/camptocamp/devops-stack-module-thanos/commit/ad510362c6b90db46e8e7d61dc4a1f12aa034511))


### Miscellaneous Chores

* release 1.0.0-alpha.8 ([#29](https://github.com/camptocamp/devops-stack-module-thanos/issues/29)) ([40db790](https://github.com/camptocamp/devops-stack-module-thanos/commit/40db790c4df850beb7677b83faaf6e323f7c57f7))

## [1.0.0-alpha.7](https://github.com/camptocamp/devops-stack-module-thanos/compare/v1.0.0-alpha.6...v1.0.0-alpha.7) (2023-01-30)


### Features

* add variable to configure sync on the application resource ([#25](https://github.com/camptocamp/devops-stack-module-thanos/issues/25)) ([f1ba6b9](https://github.com/camptocamp/devops-stack-module-thanos/commit/f1ba6b9d7d22aa88163082f43d4c29cc51362abb))

## [1.0.0-alpha.6](https://github.com/camptocamp/devops-stack-module-thanos/compare/v1.0.0-alpha.5...v1.0.0-alpha.6) (2022-12-16)


### Bug Fixes

* change values names to the same as in kube-prometheus-stack module ([#23](https://github.com/camptocamp/devops-stack-module-thanos/issues/23)) ([5e57dea](https://github.com/camptocamp/devops-stack-module-thanos/commit/5e57deacd7d8e1cac187f4d7ee581559d3ab1082))

## [1.0.0-alpha.5](https://github.com/camptocamp/devops-stack-module-thanos/compare/v1.0.0-alpha.4...v1.0.0-alpha.5) (2022-12-12)


### Features

* redesign metrics storage bucket configuration and add resources variables ([#20](https://github.com/camptocamp/devops-stack-module-thanos/issues/20)) ([f4b33ee](https://github.com/camptocamp/devops-stack-module-thanos/commit/f4b33ee6e9faca8be60aabf5e1aedf3c3e2a7340))

## [1.0.0-alpha.4](https://github.com/camptocamp/devops-stack-module-thanos/compare/v1.0.0-rc3...v1.0.0-alpha.4) (2022-10-26)


### ⚠ BREAKING CHANGES

* move Terraform module at repository root

### Features

* **thanos:** :style: add output to say thanos is enabled ([#4](https://github.com/camptocamp/devops-stack-module-thanos/issues/4)) ([6bdaec4](https://github.com/camptocamp/devops-stack-module-thanos/commit/6bdaec467751cd324e0bcf2ff6fff73760513466))
* **thanos:** deploy thanos in AWS ([#2](https://github.com/camptocamp/devops-stack-module-thanos/issues/2)) ([5b40d5b](https://github.com/camptocamp/devops-stack-module-thanos/commit/5b40d5b82fe87311a4e7f96572e6dcd46a6092c5))


### Bug Fixes

* do not delay Helm values evaluation ([dcd361c](https://github.com/camptocamp/devops-stack-module-thanos/commit/dcd361cee994e84e7c10879f16adccd31d331fbf))
* **eks:** fix recursive path that was wrongly changed on some tests ([#8](https://github.com/camptocamp/devops-stack-module-thanos/issues/8)) ([7eb0cc7](https://github.com/camptocamp/devops-stack-module-thanos/commit/7eb0cc71300566d10a119c06679ad21f5fc818c3))
* **thanos:** correct target revision and typo in comment ([#3](https://github.com/camptocamp/devops-stack-module-thanos/issues/3)) ([aba95a5](https://github.com/camptocamp/devops-stack-module-thanos/commit/aba95a590c69a2163dea6deffc66d1c9d4f57e47))


### Code Refactoring

* move Terraform module at repository root ([263b4a3](https://github.com/camptocamp/devops-stack-module-thanos/commit/263b4a36e293fe52bd30f5eee3d089297f1a0bc9))


### Continuous Integration

* add release workflow and prepare main.tf to get tag from version.txt ([#10](https://github.com/camptocamp/devops-stack-module-thanos/issues/10)) ([935217c](https://github.com/camptocamp/devops-stack-module-thanos/commit/935217cf7b427908c1e0e5d6dab9b549c8e2a122))


### Documentation

* correct typo ([#15](https://github.com/camptocamp/devops-stack-module-thanos/issues/15)) ([f85c17a](https://github.com/camptocamp/devops-stack-module-thanos/commit/f85c17a87d6f04531efb5976489f919553bb11be))


### Miscellaneous Chores

* release v1.0.0-alpha.4 ([#17](https://github.com/camptocamp/devops-stack-module-thanos/issues/17)) ([9a0b972](https://github.com/camptocamp/devops-stack-module-thanos/commit/9a0b9721aa44eb8266b3a07ddee3ad86a229156e))
* upgrade chart to v11.5.5 and reactivate thanos-sidecar ([#11](https://github.com/camptocamp/devops-stack-module-thanos/issues/11)) ([3c87c2c](https://github.com/camptocamp/devops-stack-module-thanos/commit/3c87c2cb862bee4244499bbdbfd987d103f9a4c5))

## [1.0.0-alpha.3](https://github.com/camptocamp/devops-stack-module-thanos/compare/v1.0.0-alpha.2...v1.0.0-alpha.3) (2022-10-26)


### Documentation

* correct typo ([#15](https://github.com/camptocamp/devops-stack-module-thanos/issues/15)) ([f85c17a](https://github.com/camptocamp/devops-stack-module-thanos/commit/f85c17a87d6f04531efb5976489f919553bb11be))

## [1.0.0-alpha.2](https://github.com/camptocamp/devops-stack-module-thanos/compare/v1.0.0-alpha.1...v1.0.0-alpha.2) (2022-10-24)


### Miscellaneous Chores

* upgrade chart to v11.5.5 and reactivate thanos-sidecar ([#11](https://github.com/camptocamp/devops-stack-module-thanos/issues/11)) ([3c87c2c](https://github.com/camptocamp/devops-stack-module-thanos/commit/3c87c2cb862bee4244499bbdbfd987d103f9a4c5))

## 1.0.0-alpha.1 (2022-10-24)


### ⚠ BREAKING CHANGES

* move Terraform module at repository root

### Features

* **thanos:** :style: add output to say thanos is enabled ([#4](https://github.com/camptocamp/devops-stack-module-thanos/issues/4)) ([6bdaec4](https://github.com/camptocamp/devops-stack-module-thanos/commit/6bdaec467751cd324e0bcf2ff6fff73760513466))
* **thanos:** deploy thanos in AWS ([#2](https://github.com/camptocamp/devops-stack-module-thanos/issues/2)) ([5b40d5b](https://github.com/camptocamp/devops-stack-module-thanos/commit/5b40d5b82fe87311a4e7f96572e6dcd46a6092c5))


### Bug Fixes

* do not delay Helm values evaluation ([dcd361c](https://github.com/camptocamp/devops-stack-module-thanos/commit/dcd361cee994e84e7c10879f16adccd31d331fbf))
* **eks:** fix recursive path that was wrongly changed on some tests ([#8](https://github.com/camptocamp/devops-stack-module-thanos/issues/8)) ([7eb0cc7](https://github.com/camptocamp/devops-stack-module-thanos/commit/7eb0cc71300566d10a119c06679ad21f5fc818c3))
* **thanos:** correct target revision and typo in comment ([#3](https://github.com/camptocamp/devops-stack-module-thanos/issues/3)) ([aba95a5](https://github.com/camptocamp/devops-stack-module-thanos/commit/aba95a590c69a2163dea6deffc66d1c9d4f57e47))


### Code Refactoring

* move Terraform module at repository root ([263b4a3](https://github.com/camptocamp/devops-stack-module-thanos/commit/263b4a36e293fe52bd30f5eee3d089297f1a0bc9))


### Continuous Integration

* add release workflow and prepare main.tf to get tag from version.txt ([#10](https://github.com/camptocamp/devops-stack-module-thanos/issues/10)) ([935217c](https://github.com/camptocamp/devops-stack-module-thanos/commit/935217cf7b427908c1e0e5d6dab9b549c8e2a122))
