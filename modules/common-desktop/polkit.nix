{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.writeTextDir "share/polkit-1/actions/com.henryhiles.quados.policy" ''
<!DOCTYPE policyconfig PUBLIC '-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN' 'http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd'>

<policyconfig>
  <action id='com.henryhiles.quados.rebuild'>
    <description>Rebuild</description>
    <message>Authentication is required to rebuild the system</message>
    <defaults>
      <allow_any>auth_admin_keep</allow_any>
      <allow_inactive>auth_admin_keep</allow_inactive>
      <allow_active>auth_admin_keep</allow_active>
    </defaults>
    <annotate key='org.freedesktop.policykit.exec.path'>/run/current-system/sw/bin/flatpak</annotate>
  </action>
</policyconfig>
      '')
  ];
}