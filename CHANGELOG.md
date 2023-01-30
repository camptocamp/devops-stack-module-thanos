# Changelog

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
