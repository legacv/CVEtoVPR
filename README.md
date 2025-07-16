# CVEtoVPR
Bash script for fetching the Tenable VPR score for a given CVE or list of CVEs. Does not work properly as of 7/16/25.
## Usage
`git clone https://github.com/legacv/CVEtoVPR && cd CVEtoVPR`

Create .env file in CVEtoVPR directory:
```
TENABLE_ACCESS_KEY=<your Tenable access key>
TENABLE_SECRET_KEY=<your Tenable secret key>
```

...or replace `source .env` in `fetchvpr.sh` with variables `TENABLE_ACCESS_KEY` and `TENABLE_SECRET_KEY` (not recommended).

`chmod +x ./fetchvpr.sh`

`./fetchvpr.sh`
## TODO
Modify initial dictionary-build endpoint(!!)

Test list functionality

Add support for multiple CVE formats

Clarify --help/usage

Add long-form versions of flags

Create a Python version of this script(?)

---

ฅᨐฅ 100% human-made ฅᨐฅ
