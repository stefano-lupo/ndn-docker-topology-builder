cxx_repo="https://github.com/named-data/ndn-cxx.git"
cxx_release_tag="ndn-cxx-0.6.5"
cxx_dir="ndn-cxx"

nfd_repo="https://github.com/named-data/NFD.git"
nfd_release_tag="NFD-0.6.5"
nfd_dir="nfd-0.6.5"

chronosync_repo="https://github.com/named-data/ChronoSync.git"
chronosync_release_tag="0.5.2"
chronosync_dir="chronosync-0.5.2"

psync_repo="https://github.com/named-data/PSync.git"
psync_release_tag="0.1.0"
psync_dir="psync-0.1.0"

nlsr_repo="https://github.com/named-data/NLSR.git"
nlsr_release_tag="NLSR-0.4.3"
nlsr_hash="85998a1dc942974a7d4bf3e9f642c5a22dffb6f8"
nlsr_dir="nlsr-0.4.3"

function install() {
  git_repo=$1
  tag=$2
  release_dir_name=$3

  git_command="git clone --depth 1 --branch $tag $git_repo $release_dir_name"

  
  if [ $git_repo == $nfd_repo ]
  then
    echo "Updating submodule for " $git_repo
    git submodule update --init
    git_command="$git_commandmmand --recursive"
  elif [ $git_repo == $nlsr_repo ]
  then
    git_command="git clone $git_repo $release_dir_name && git checkout $nlsr_hash"
  fi

  $git_command
  cd $release_dir_name

  ./waf distclean
  echo "Finished cleaning"

  ./waf configure
  echo "Finished configuring, compiling"

  ./waf -j4
  echo "Finished compiling, installing"

  ./waf install

  cd ../
}

apt update && app install -y \
  build-essential \
  git \
  libsqlite3-dev \
  libboost-all-dev \
  libssl-dev \
  libpcap-dev \
  pkg-config \
  python \


# NDN Cxx
install $cxx_repo $cxx_release_tag $cxx_dir
ldconfig

# NFD
install $nfd_repo $nfd_release_tag $nfd_dir

# Use initial config file for now
# cp /usr/local/etc/ndn/nfd.conf.sample /usr/local/etc/ndn/nfd.conf

# # Create the NFD service
# cp nfd.service /etc/systemd/system/
# systemctl start nfd.service
# systemctl enable nfd.service

# Install ChronoSync
install $chronosync_repo $chronosync_release_tag $chronosync_dir

# Install PSync
install $psync_repo $psync_release_tag $psync_dir

# Install NLSR
install $nlsr_repo $nlsr_release_tag $nlsr_dir
