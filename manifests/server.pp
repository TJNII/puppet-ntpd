class ntp::server( $manage_firewall = true ) {
  
   case $operatingsystem {
      centos, redhat: { 
         $service_name = 'ntpd'
      }
      debian, ubuntu: { 
         $service_name = 'ntp'
      }
   }

   $ntp_servers = [ "0.pool.ntp.org",
                    "1.pool.ntp.org",
                    "2.pool.ntp.org",
                    "3.pool.ntp.org", ]

   package { 'ntp':
      ensure => installed,
   }
      
   service { 'ntp':
      name      => $service_name,
      ensure    => running,
      enable    => true,
      subscribe => File['ntp.conf'],
   }
      
   file { 'ntp.conf':
      path    => '/etc/ntp.conf',
      ensure  => file,
      require => Package['ntp'],
      content  => template("ntp/ntp.conf.erb"),
   }

  if $manage_firewall == true {
    include firewall-config::base
    
    firewall { '100 allow NTP':
     state => ['NEW'],
     dport => '123',
     proto => 'udp',
     action => accept,
   }
  }
   
}
