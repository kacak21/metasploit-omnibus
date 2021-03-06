#
# Copyright 2014 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# libyaml 0.1.5 fixes a security vulnerability to 0.1.4.
# Since the rubyinstaller.org doesn't release ruby when a dependency gets
# patched, we are manually patching the dependency until we get a new
# ruby release on windows.
# See: https://github.com/oneclick/rubyinstaller/issues/210
# This component should be removed when libyaml 0.1.5 ships with ruby builds
# of rubyinstaller.org
#
name "libyaml-windows"
default_version "0.1.6"

dependency "ruby-windows"

source url: "http://packages.openknapsack.org/libyaml/libyaml-0.1.6-x86-windows.tar.lzma",
       md5: "8bb5d8e43cf18ec48b4751bdd0111c84"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  tmpdir = File.join(Omnibus::Config.cache_dir, "libyaml-cache")

  # Ensure the directory exists
  mkdir tmpdir

  # First extract the tar file out of lzma archive.
  command "7z.exe x #{project_file} -o#{tmpdir} -r -y", env: env

  # Now extract the files out of tar archive.
  command "7z.exe x #{File.join(tmpdir, "libyaml-0.1.6-x86-windows.tar")} -o#{tmpdir} -r -y", env: env

  # Now copy over libyaml-0-2.dll to the build dir
  copy "#{tmpdir}/bin/libyaml-0-2.dll", "#{install_dir}/embedded/bin/libyaml-0-2.dll"
end
