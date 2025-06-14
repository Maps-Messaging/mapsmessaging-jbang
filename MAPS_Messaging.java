//usr/bin/env jbang "$0" "$@" ; exit $?
//JAVA 21+

import java.io.File;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class MAPS_Messaging {
    private static final Logger logger = Logger.getLogger(MAPS_Messaging.class.getName());

    public static void main(String[] args) {
        try {
            // Set up the installation directory
            String homeDir = System.getProperty("user.dir");
            String mapsHome = homeDir + File.separator + "maps-ml-3.3.7-SNAPSHOT";
            System.setProperty("MAPS_HOME", mapsHome);
            System.out.println("Using MAPS_HOME: " + mapsHome);
            
            // Create necessary directories
            new File(mapsHome).mkdirs();
            new File(mapsHome + File.separator + "config").mkdirs();
            new File(mapsHome + File.separator + "logs").mkdirs();
            
            // Copy JDK to maps-ml directory
            String javaHome = System.getProperty("java.home");
            String jdkDir = mapsHome + File.separator + "jdk";
            new File(jdkDir).mkdirs();
            
            // Build classpath with conf, main JAR, and all lib/*.jar
            StringBuilder cp = new StringBuilder(mapsHome + File.separator + "conf");
            cp.append(File.pathSeparator).append(mapsHome + File.separator + "lib" + File.separator + "maps-ml-3.3.7-SNAPSHOT.jar");
            cp.append(File.pathSeparator).append(mapsHome + File.separator + "lib" + File.separator + "*");
            
            // Prepare environment for the subprocess
            Map<String, String> env = new HashMap<>();
            env.put("MAPS_HOME", mapsHome);
            env.put("MAPS_DATA", mapsHome + File.separator + "data");
            env.put("MAPS_LIB", mapsHome + File.separator + "lib");
            env.put("MAPS_CONF", mapsHome + File.separator + "conf");
            
            // Build the command to launch MessageDaemon
            List<String> cmd = new ArrayList<>();
            cmd.add("java");
            cmd.add("-classpath");
            cmd.add(cp.toString());
            cmd.add("-DUSE_UUID=false");
            cmd.add("-Djava.security.auth.login.config=" + mapsHome + File.separator + "conf/jaasAuth.config");
            cmd.add("-DMAPS_HOME=" + mapsHome);
            cmd.add("io.mapsmessaging.MessageDaemon");
            cmd.addAll(List.of(args));
            
            // Start the process
            ProcessBuilder pb = new ProcessBuilder(cmd)
                .directory(new File(mapsHome));
            pb.environment().putAll(env);
            pb.inheritIO();
            
            Process proc = pb.start();
            proc.waitFor();
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error starting server", e);
            System.exit(1);
        }
    }
}
