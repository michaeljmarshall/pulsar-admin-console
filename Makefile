# Copyright 2021
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

all: container

#
# Docker tag with v prefix to differentiate the official release build, triggered by git tagging
#
TAG ?= v0.0.4
PREFIX ?= datastax/pulsar-admin-console

container:
	docker build -t $(PREFIX):$(TAG) .
	docker tag $(PREFIX):$(TAG) ${PREFIX}:latest 

push: container
	docker push $(PREFIX):$(TAG)
	docker push $(PREFIX):latest

clean:
	docker rmi $(PREFIX):$(TAG)

tarball:
	rm -rf pulsar-admin-console-$(TAG)/
	docker create -ti --name pac-tarball $(PREFIX):$(TAG) sh
	docker cp pac-tarball:/home/appuser/ pulsar-admin-console-$(TAG)/
	docker rm -f pac-tarball
	tar -czf pulsar-admin-console-$(TAG).tar.gz pulsar-admin-console-$(TAG)/
	rm -r pulsar-admin-console-$(TAG)/
	openssl dgst -sha512 pulsar-admin-console-$(TAG).tar.gz
