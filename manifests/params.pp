# == Class: uwsgi::params
# Default parameters for configuring and installing
# uwsgi
#
# === Authors:
# - Josh Smeaton <josh.smeaton@gmail.com>
#
class uwsgi::params {
    $package_name        = 'uwsgi'
    $package_ensure      = 'installed'
    $package_provider    = 'pip'
    $service_name        = 'uwsgi'
    $service_ensure      = true
    $service_enable      = true
    $manage_service_file = true
    $config_file         = '/etc/uwsgi.ini'
    $tyrant              = true
    $install_pip         = true
    $install_python_dev  = true
    $log_file            = '/var/log/uwsgi/uwsgi-emperor.log'
    $log_rotate          = 'no'
    $python_pip          = 'python-pip'

    case $::osfamily {
        redhat: {
            $app_directory = '/etc/uwsgi.d'
            $python_dev    = 'python-devel'
            if versioncmp($::operatingsystemrelease, 7) > 0 {
              $service_provider  = 'systemd'
              $service_file      = '/etc/systemd/system/uwsgi.service'
              $service_file_mode = '0664'
              $service_template  = 'uwsgi/uwsgi_systemd.erb'
              $socket            = '/run/uwsgi/uwsgi.socket'
              $pidfile           = '/run/uwsgi/uwsgi.pid'
            } else {
              $service_provider  = 'redhat'
              $service_file      = '/etc/init.d/uwsgi'
              $service_file_mode = '0755'
              $service_template  = 'uwsgi/uwsgi_redhat_lsb.erb'
              $socket            = '/var/run/uwsgi/uwsgi.socket'
              $pidfile           = '/var/run/uwsgi/uwsgi.pid'
            }
        }
        default: {
            $app_directory     = '/etc/uwsgi/apps-enabled'
            $pidfile           = '/run/uwsgi/uwsgi.pid'
            $python_dev        = 'python-dev'
            $socket            = '/run/uwsgi/uwsgi.socket'
            $service_provider  = 'upstart'
            $service_file      = '/etc/init/uwsgi.conf'
            $service_file_mode = '0755'
            $service_template  = 'uwsgi/uwsgi_upstart.erb'
        }
    }
}
