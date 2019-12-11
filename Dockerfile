#
# Pull base image
# ---------------
FROM oracle/serverjre:7

# Environment variables required for this build
# ---------------------------------------------
ENV ORACLE_HOME=/u01/oracle \
    USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom" \
    PATH=$PATH:/usr/java/default/bin:/u01/oracle/oracle_common/common/bin

# Setup required packages, filesystem, and oracle user.
# Install and configure Oracle JDK
# Adjust file permissions, go to /u01 as user 'oracle' to proceed with WLS installation
# ------------------------------------------------------------
RUN mkdir -p /u01 && \
    chmod a+xr /u01 && \
    useradd -b /u01 -d /u01/oracle -m -s /bin/bash oracle

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV FMW_PKG=wls1213_dev_update3.zip \
    MW_HOME=/u01/oracle


# Copy packages
# -------------
COPY $FMW_PKG /u01/
RUN  chown oracle:oracle -R /u01


# Setup filesystem and oracle user
# Install and configure Oracle JDK
# Adjust file permissions, go to /u01 as user 'oracle' to proceed with WLS installation
# ------------------------------------------------------------
RUN $JAVA_HOME/bin/jar xf /u01/$FMW_PKG && \
    mv wls12130/* $ORACLE_HOME && rmdir wls12130 && \
    cd $ORACLE_HOME && \
    sh configure.sh -silent && \
    find $ORACLE_HOME -name "*.sh" -exec chmod a+x {} \; && \
    rm /u01/$FMW_PKG

WORKDIR $ORACLE_HOME
USER oracle

# Define default command to start bash.
CMD ["bash"]
