#!/bin/sh
# Please run this script as root.

SYSTEM=`uname -s`

if [ -s /etc/redhat-release ]; then
	# Includes Fedora, CentOS
	if [ -f /etc/centos-release ]; then
		# Add EPEL repository for CUnit-devel
		yum --enablerepo=extras install -y epel-release
	fi
	yum install -y gcc gcc-c++ make CUnit-devel libaio-devel openssl-devel \
		git astyle python-pep8 lcov python clang-analyzer libuuid-devel \
		sg3_utils libiscsi-devel
	# Additional (optional) dependencies for showing backtrace in logs
	yum install -y libunwind-devel
	# Additional dependencies for NVMe over Fabrics
	yum install -y libibverbs-devel librdmacm-devel
	# Additional dependencies for DPDK
	yum install -y numactl-devel nasm
	# Additional dependencies for building docs
	yum install -y doxygen mscgen graphviz
	# Additional dependencies for building pmem based backends
	yum install -y libpmemblk-devel || true
	# Additional dependencies for SPDK CLI
	yum install -y python-configshell python-pexpect python3-configshell python3-pexpect
elif [ -f /etc/debian_version ]; then
	# Includes Ubuntu, Debian
	apt-get install -y gcc g++ make libcunit1-dev libaio-dev libssl-dev \
		git astyle pep8 lcov clang uuid-dev sg3-utils libiscsi-dev
	# Additional (optional) dependencies for showing backtrace in logs
	apt-get install libunwind-dev
	# Additional dependencies for NVMe over Fabrics
	apt-get install -y libibverbs-dev librdmacm-dev
	# Additional dependencies for DPDK
	apt-get install -y libnuma-dev nasm
	# Additional dependencies for building docs
	apt-get install -y doxygen mscgen graphviz
	# Additional dependencies for SPDK CLI
	apt-get install -y python-pip python3-pip
	pip install configshell_fb pexpect
	pip3 install configshell_fb pexpect
elif [ -f /etc/SuSE-release ]; then
	zypper install -y gcc gcc-c++ make cunit-devel libaio-devel libopenssl-devel \
		git-core lcov python-base python-pep8 libuuid-devel sg3_utils
	# Additional (optional) dependencies for showing backtrace in logs
	zypper install libunwind-devel
	# Additional dependencies for NVMe over Fabrics
	zypper install -y rdma-core-devel
	# Additional dependencies for DPDK
	zypper install -y libnuma-devel nasm
	# Additional dependencies for building pmem based backends
	zypper install -y libpmemblk-devel
	# Additional dependencies for building docs
	zypper install -y doxygen mscgen graphviz
elif [ $SYSTEM = "FreeBSD" ] ; then
	pkg install -y gmake cunit openssl git devel/astyle bash py27-pycodestyle \
		python misc/e2fsprogs-libuuid sysutils/sg3_utils nasm
	# Additional dependencies for building docs
	pkg install -y doxygen mscgen graphviz
else
	echo "pkgdep: unknown system type."
	exit 1
fi
