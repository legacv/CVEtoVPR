# CVEtoVPR
Bash script for fetching the Tenable VPR score for a given CVE or list of CVEs.
## Usage
`git clone https://github.com/legacv/CVEtoVPR && cd CVEtoVPR`
Create .env file in CVEtoVPR directory with `TENABLE_ACCESS_KEY` and `TENABLE_SECRET_KEY` set
`chmod +x ./fetchvpr.sh`
`./fetchvpr.sh`
...or replace `source .env` in `fetchvpr.sh` with variables `TENABLE_ACCESS_KEY` and `TENABLE_SECRET_KEY` (not recommended).
## TODO
Add a Python version of this script.