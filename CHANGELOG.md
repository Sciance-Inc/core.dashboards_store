# CHANGELOG


## v0.8.2+20231206 (2023-12-06)

### Fix

* fix(adapter): swtich the adapter from dbt-sqlserver to fabric (#26)

Co-authored-by: hugo juhel &lt;juhel.hugo@stratemia.com&gt; ([`9b507f5`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9b507f5a367ac7600f2027c656435982dc9c3399))


## v0.8.1+20231114 (2023-11-14)

### Fix

* fix(typo): various dashboards typo adjustements (#23)

Co-authored-by: hugo juhel &lt;juhel.hugo@stratemia.com&gt;
Co-authored-by: Gabriel Thiffault &lt;147753578+gabrielThiffault@users.noreply.github.com&gt; ([`48ee40c`](https://github.com/Sciance-Inc/core.dashboards_store/commit/48ee40cf32ebdd4ebd1b3cb6189e7e00a52d6492))

## v0.8.0+20231102 (2023-11-02)

### Feature

* feat: releasing news changes of v0.8.0 (#16)

Co-authored-by: juhel hugo &lt;juhel.hugo@stratemia.com&gt;
Co-authored-by: github-actions &lt;github-actions@github.com&gt;
Co-authored-by: Mohamed Sadqi &lt;sadqim@csvdc.qc.ca&gt;
Co-authored-by: sadqim &lt;146247957+sadqim@users.noreply.github.com&gt;
Co-authored-by: ZhuravlovaMaryna &lt;147752681+ZhuravlovaMaryna@users.noreply.github.com&gt;
Co-authored-by: semantic-release &lt;semantic-release&gt; ([`ad2b5d3`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ad2b5d3d620b2d274ffbabe7729c0e0a2b22f43d))

## v0.7.0+20230926 (2023-09-26)

### Chore

* chore: gitignoring the pbix ([`cb92a3d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/cb92a3d35c6f6417ab7ad36642e23d8bd7ed6d28))

### Feature

* feat: adding dashboards ([`7ab3ec2`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7ab3ec2bb1249e10fe2aa94943176841cf9b2280))


## v0.6.2+20230913 (2023-09-13)

### Documentation

* docs(fix): updatating the stamp_model&#39;s macro name ([`404c505`](https://github.com/Sciance-Inc/core.dashboards_store/commit/404c50554330cb1b2767230c7c56a6f45fad19b9))


## v0.6.2+20230831 (2023-08-31)


### Chore

* chore(cicd): adding concurrency piority ([`dbff52c`](https://github.com/Sciance-Inc/core.dashboards_store/commit/dbff52c6c90b055510733b4b00811304c1bcc58f))

### Fix

* fix(cicd): adding job scope to group name ([`508f8de`](https://github.com/Sciance-Inc/core.dashboards_store/commit/508f8de800f145202bf23de0419053f61e1baa3c))

### Style

* style: applying sqlfmt ([`b822989`](https://github.com/Sciance-Inc/core.dashboards_store/commit/b82298934ab59740fe2ece0097eb2f44d63d579b))

### Unknown

* Merge branch &#39;master&#39; into develop ([`0bf1d28`](https://github.com/Sciance-Inc/core.dashboards_store/commit/0bf1d282a29f4a166a1fb6a58310cdee3d3d0484))

* Merge branch &#39;develop&#39; of github.com:Sciance-Inc/core.dashboards_store into develop ([`b0cf8f9`](https://github.com/Sciance-Inc/core.dashboards_store/commit/b0cf8f999e179c76193b3c8dc0dc4b8164e2f982))


## v0.6.0+20230831 (2023-08-31)

### Chore

* chore(test): adding the stable version to the nightly build ([`ad7fc6c`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ad7fc6c7c4e0aef4c338049830a0a19c306ed460))

* chore(cicd): fixing maximal matrix concurrency to 1 to avoid burning the database ([`e22153a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/e22153a163345ae009ce9524a3507a8673deab28))

* chore(fix): logging to the github registry before pushing the docker ([`493e726`](https://github.com/Sciance-Inc/core.dashboards_store/commit/493e726ffd8395aa2ab3f46c6e1e4eff7d470fc2))

* chore(cicd): adding the command to run the integration tests suite ([`da003f3`](https://github.com/Sciance-Inc/core.dashboards_store/commit/da003f39d1925e5c50575d1c438ae98c3df187d2))

* chore: trigger the nightly on master ([`5e34159`](https://github.com/Sciance-Inc/core.dashboards_store/commit/5e34159c32fcd697667b1abdda44bfcae95134f6))

* chore: adding CICD pipeline for nightly release ([`1fc829f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/1fc829ffe2b1e1f82f94fea1790bb8ff5d82492a))

* chore(test): adding the dockerfile and the required files to run the integration tests ([`c99333d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c99333dfbd03f8296d0fe61724fbc7a829884019))

### Documentation

* docs: updating both the readme and the PR template to help developers populating seeds in the nightly project ([`2a1b15f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2a1b15fff10c8c765eeab5f4676753f83fc4ec5f))

* docs(test): adding an how-to about the way to run the integration test on your local computer ([`dc05178`](https://github.com/Sciance-Inc/core.dashboards_store/commit/dc05178f21798eeaecbed9ca34b305e401af57a3))

### Test

* test(fix): fixing the test populations ([`6be75a0`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6be75a085ab0d9fd5e5e6065b4f75fd2e9e9bebd))

* test: adding a simple /default dbt project to be run as an integration test ([`46bc620`](https://github.com/Sciance-Inc/core.dashboards_store/commit/46bc6200e358b343779523da179bdfe4ff856c12))

## v0.5.3 (2023-08-31)

### Fix

* fix: adding dummy id_eco to custom_fgj_population so the table is now working when not overrided ([`4cb464c`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4cb464c115a88a3ba9bb8c639ddcbac0684eba0c))

* fix: the default empty custom population now properly support the id_eco ([`17e25e9`](https://github.com/Sciance-Inc/core.dashboards_store/commit/17e25e9a0f4336fb868272ecd52f08f472998604))


## v0.5.2 (2023-08-30)


## v0.6.0-dev.3+20230830 (2023-08-30)

### Fix

* fix: adding the missing is_context_core variable to the cookiecutter

commit 541e66cd7e66564c2c16c99e27da30538469c3b8
Author: hugo juhel &lt;juhel.hugo@stratemia.com&gt;
Date:   Wed Aug 30 12:58:33 2023 -0400

    fix: adding the missing is_context_core variable to the cookiecutter ([`3e57cf2`](https://github.com/Sciance-Inc/core.dashboards_store/commit/3e57cf26677ca94b5a52a4594049efbf7401975b))

### Unknown

* Merge tag &#39;core_context&#39; into develop

v0.5.2 ([`3d3d924`](https://github.com/Sciance-Inc/core.dashboards_store/commit/3d3d924251f4e4aa462cf5b9bb6ea6455cfb891c))

## v0.5.1 (2023-08-30)

### Fix

* fix: dependencies will now be parsed as ref when source are used and is_context_core is set to false ([`a8316f7`](https://github.com/Sciance-Inc/core.dashboards_store/commit/a8316f7346e4c62725eeea6f76eff77468cc2e6a))

* fix: dependencies will now be parsed as ref when source are used and is_context_core is set to false ([`8a97d08`](https://github.com/Sciance-Inc/core.dashboards_store/commit/8a97d08db0615440925c82a7f236f6d412cc2a31))


## v0.5.0 (2023-08-28)

### Build

* build: pining sr version ([`7f2f78a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7f2f78a55d96de77265b5341cc86357d150b9d55))

* build: casting the timeout as integer to allow for string like definition in the inherited dags ([`2f99f7f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2f99f7f88374032484b746d86750dcd7fd8b49c7))

### Chore

* chore: updating PR template ([`1abf722`](https://github.com/Sciance-Inc/core.dashboards_store/commit/1abf722c9adc2b84a3e1f9f8acb638fd4201c6b8))

### Documentation

* docs: fixing typo in the gpi&#39;s database name ([`02ae6f7`](https://github.com/Sciance-Inc/core.dashboards_store/commit/02ae6f75b3c1898d316e8745c40012eeb06496dc))

### Feature

* feat: add id_eco to population table and add population template