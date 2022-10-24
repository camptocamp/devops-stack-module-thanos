# Changelog

## 1.0.0-rc1 (2022-10-24)


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