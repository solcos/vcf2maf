# vcf2maf
Repository to create a docker container with vcf2maf and vep.

## Code

### Clone the repository
$ git clone

### Build the container
$ docker build -t vcf2maf:latest .

### Run the container (two volumes, one (my_data) for the data to use inside the container and the second (.vep) where the vep data (cache files and reference genomes) is)
$ docker run -v /vault/bio-scratch/arnau/vcf2maf_container_data/my_data:/vcf2maf/vcf2maf-1.6.21/my_data -v /vault/bio-scratch/arnau/vcf2maf_container_data/vep_data/.vep:/root/.vep -tid --name vcf2maf vcf2maf:latest

### Get inside the container
$ docker exec -it vcf2maf bash

### Install vep dependencies
$ cd ../ensembl-vep/ 
$ perl INSTALL.pl

#### Download cache files, reference genome files and plugins if needed. You can use a volume with cache files already downloaded in it.

### Come back to the working direcotry
$ cd ../vcf2maf-1.6.21

### Example of vcf2maf
$ perl vcf2maf.pl --input-vcf tests/test.vcf --output-maf tests/test.vep2.maf --vep-path /./vcf2maf/ensembl-vep --ref-fasta /root/.vep/homo_sapiens/109_GRCh37/Homo_sapiens.GRCh37.dna.toplevel.fa
