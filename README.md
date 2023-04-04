# vcf2maf
Repository to create a docker container with vcf2maf and vep.

# Code

## Clone the repository
$ git clone

## Build the container
$ docker build -t vcf2maf:latest .

## Run the container (two volumes, one (my_data) for the data to use inside the container and the second (.vep) where the vep data (cache files and reference genomes) is)
$ docker run -v /vault/bio-scratch/arnau/vcf2maf_container_data/my_data:/vcf2maf/vcf2maf-1.6.21/my_data -v /vault/bio-scratch/arnau/vcf2maf_container_data/vep_data/.vep:/root/.vep -tid --name vcf2maf vcf2maf:latest

## Get inside the container
$ docker exec -it vcf2maf bash

## Install vep dependencies
$ cd ../ensembl-vep/ 
$ perl INSTALL.pl

## Download cache files, reference genome files and plugins if needed.

## Come back to the working direcotry
$ cd ../vcf2maf-1.6.21
