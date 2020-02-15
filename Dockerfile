FROM mcr.microsoft.com/dotnet/core/aspnet:3.1.0-alpine3.10 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1.100-buster AS build
WORKDIR /src
COPY ["ConfigMapInK8s.csproj", "./"]

RUN dotnet restore "./ConfigMapInK8s.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ConfigMapInK8s.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ConfigMapInK8s.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ConfigMapInK8s.dll"]