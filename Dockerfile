# 使用适当的基础映像
FROM openjdk:11-jdk-slim AS build

# 设置工作目录
WORKDIR /app

# 复制 Maven 构建文件
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# 构建项目依赖
RUN ./mvnw dependency:go-offline

# 复制源代码并构建应用程序
COPY src ./src
RUN ./mvnw package -DskipTests

# 构建用于生产的镜像
FROM openjdk:11-jre-slim
WORKDIR /app

# 从构建阶段复制构建的应用程序
COPY --from=build /app/target/my-application.jar .

# 设置容器启动命令
CMD ["java", "-jar", "my-application.jar"]
