class repo {
  include apt

  apt::sources_list {"groonga":
      ensure  => present,
      content => 'deb http://packages.groonga.org/ubuntu/ precise universe',
  }

  apt::key {"FFB4B2A2":
    content =>
"-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.11 (GNU/Linux)

mI0ESqTVdQEEAJ0sE3+S2URYFqKgs3G9ZqIyGHLWhKMDd1T3q4VqDjlIA+tf4Rp+
7pImYE//ZqtCMFpO+PyeP3g72XxCjwDdoLkxZyHcBPXHPRrVn6fNr8fHW9gQ3U28
pKR+Qk9cNn57gZKgfvUyqEuX+yzoo64AD88hX/a7OpHnUrqQMIOrEc5NABEBAAG0
GExhdW5jaHBhZCBkZWxsLW1pbmktcGx1c4i2BBMBAgAgBQJKpNV1AhsDBgsJCAcD
AgQVAggDBBYCAwECHgECF4AACgkQeIRNEv+0sqKiNQP6A+CNvY10TMuEF47QJNHd
IG7L3MaD1hOixrkNBJ64iMSzyDWgVEO/2HUbh7bJOi+TPlklTVl39zGiQVXUDk8L
0e10SsCSuuvZCOQ94EI1HU01N1f8G9LlXh4pxSoL6BomT8pDu4ojfg9mGWhLsd0C
QlSMfRUk97643Co24KmjpM8=
=bc2P
-----END PGP PUBLIC KEY BLOCK-----",
  }

  apt::sources_list {"ppa-miurahr":
      ensure  => present,
      content => 'deb http://ppa.launchpad.net/miurahr/openresty/ubuntu precise main',
  }

#  apt::ppa {
#    'miurahr':
#      ensure   => present,
#      key      => 'FFB4B2A2',
#      ppa      => 'openresty'
#  }


  apt::key {"45499429":
      content  => "-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.12 (GNU/Linux)

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
09GjfEljeEnXotmlXjJTZPLg
=r2Wo
-----END PGP PUBLIC KEY BLOCK-----",
  }

  exec {"apt-get install -y patch":
    command => "/usr/bin/apt-get install -y patch"
  }
}
