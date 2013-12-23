define apt::key (
  $keyserver = 'pgp.mit.edu',
  $ensure  = present,
  $source  = '',
  $content = ''
) {

  case $ensure {

    present: {
      if $content == '' {
        if $source == '' {
          $thekey = "/usr/bin/gpg --keyserver ${keyserver} --recv-key '${name}' && /usr/bin/gpg --export --armor '${name}'"
        }
        else {
          $thekey = "/usr/bin/wget -O - '${source}'"
        }
      }
      else {
        $thekey = "/bin/echo '${content}'"
      }


      exec { "import gpg key ${name}":
        command => "${thekey} | /usr/bin/apt-key add -",
        unless  => "/usr/bin/apt-key list | /bin/grep -Fe '${name}' | /bin/grep -Fvqe 'expired:'",
        before  => Exec['apt-get_update'],
        notify  => Exec['apt-get_update'],
      }
    }

    absent: {
      exec {"apt-key del ${name}":
        onlyif => "/usr/bin/apt-key list | /bin/grep -Fqe '${name}'",
      }
    }

    default: {
      fail "Invalid 'ensure' value '${ensure}' for apt::key"
    }

  }
}
