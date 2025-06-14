# Use a base image with Java 21
FROM eclipse-temurin:21-jdk

# Set working directory
WORKDIR /app

# Install curl and other dependencies
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Install JBang
RUN curl -Ls https://sh.jbang.dev | bash -s - app setup

# Add JBang to PATH
ENV PATH="/root/.jbang/bin:${PATH}"

# Trust the Maps-Messaging organization
RUN jbang trust add https://github.com/Maps-Messaging/

# Install MAPS Messaging
RUN jbang app install --fresh --force https://github.com/Maps-Messaging/mapsmessaging-jbang/blob/main/MAPS_Messaging.java

# Create a symlink for the mapsmessaging command
RUN ln -sf /root/.jbang/bin/MAPS_Messaging /root/.jbang/bin/mapsmessaging && \
    chmod +x /root/.jbang/bin/mapsmessaging

# Expose the default MAPS Messaging port
EXPOSE 8080

# Set the entrypoint
ENTRYPOINT ["mapsmessaging"] 