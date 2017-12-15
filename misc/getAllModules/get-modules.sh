ssh openbravo@butler.openbravo.com -p19198 "/home/openbravo/alo/getAllModules/get-modules.sh"
rsync -Pav -e "ssh -p19198" openbravo@butler.openbravo.com:/tmp/allMods.tgz .
ssh openbravo@butler.openbravo.com -p19198 "rm /tmp/allMods.tgz"
