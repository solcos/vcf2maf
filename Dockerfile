# Download base image ubuntu 22.04
FROM ubuntu:22.04

LABEL maintainer="Arnau Soler"
LABEL version="0.0.1"
LABEL description="This is a custom Docker Image for the using of vcf2maf package"

# Conda path
ENV PATH="/root/miniconda3/bin:$PATH"
ARG PATH="/root/miniconda3/bin:$PATH"

# Update Ubuntu Software repository
RUN apt-get update && \
    apt-get install -y wget git perl vim

RUN apt-get install -y cpanminus build-essential && \
    cpanm Archive::Zip && apt-get install -y libdbi-perl libxml-parser-perl libnet-ssleay-perl libxml-libxml-perl libpadwalker-perl libset-object-perl libmysqlclient-dev libdbd-mysql-perl libarchive-extract-perl && \ 
    apt-get install -y gzip tar unzip
RUN cpanm DBD::mysql && \
    cpanm Bio::Root::Version && \
    cpanm Module::Build
 
# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

# Dependencies for vep
RUN apt-get install -y libncurses-dev liblzma-dev libbz2-dev libcurl4-openssl-dev

# Install samtools v1.17
RUN wget https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2
RUN tar -xvjf samtools-1.17.tar.bz2
WORKDIR samtools-1.17
#RUN ./configure
RUN make
RUN make install
RUN export PATH=$PATH:/samtools-1.17 
WORKDIR /

# Install bcftools v1.17
RUN wget https://github.com/samtools/bcftools/releases/download/1.17/bcftools-1.17.tar.bz2
RUN tar -xvjf bcftools-1.17.tar.bz2
WORKDIR bcftools-1.17
RUN make
RUN make install
RUN export PATH=$PATH:/bcftools-1.17             
WORKDIR /

# Install htslib v1.17
RUN wget https://github.com/samtools/htslib/releases/download/1.17/htslib-1.17.tar.bz2
RUN tar -xvjf htslib-1.17.tar.bz2
WORKDIR htslib-1.17
RUN make
RUN make install
RUN export PATH=$PATH:/htslib-1.17             
WORKDIR /

# Other dependencies
RUN cpan Bio::DB::HTS && \
    cpan HTTP::Tiny && \
    cpan LWP::Simple && \ 
    cpan Bio::DB::Fasta && \
    apt-get install -y curl

# Install ucsc-liftover
RUN conda install -qy -c bioconda ucsc-liftover

# Other packages
RUN apt-get install -y libbz2-dev liblzma-dev

# VEP
# At date 21/02/2023 - vep version = 109
RUN git clone https://github.com/Ensembl/ensembl-vep

# vcf2maf (v1.6.21)
RUN wget https://github.com/mskcc/vcf2maf/archive/refs/tags/v1.6.21.tar.gz
RUN tar xvzf v1.6.21.tar.gz

# Create working dir
RUN mkdir -p vcf2maf

# Create .vep folder to have everything related to vep
RUN mkdir -p /root/.vep

# Move vep and vcf2maf folders to the workdir folder
RUN mv vcf2maf-1.6.21 vcf2maf/
RUN mv ensembl-vep vcf2maf/

# Copy vcf2maf.pl changed (--af_esp removed)
COPY vcf2maf.pl /vcf2maf/vcf2maf-1.6.21

# Set workdir folder
WORKDIR vcf2maf/vcf2maf-1.6.21
