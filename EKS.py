# Importar las bibliotecas necesarias
from kubernetes import client, config

# Cargar la configuración de Kubernetes desde el archivo kubeconfig
config.load_kube_config()

# Crear un cliente de la API de Kubernetes que puede interactuar con el clúster
api_client = client.ApiClient()

# Definir un objeto de despliegue que describe la aplicación Flask
deployment = client.V1Deployment(
    # Metadatos del despliegue, incluyendo el nombre
    metadata=client.V1ObjectMeta(name="my-flask-app"),
    spec=client.V1DeploymentSpec(
        # El número de réplicas del despliegue
        replicas=1,
        # El selector para encontrar las réplicas
        selector=client.V1LabelSelector(
            match_labels={"app": "my-flask-app"}
        ),
        # La plantilla del pod que se utilizará para las réplicas
        template=client.V1PodTemplateSpec(
            # Los metadatos del pod, incluyendo las etiquetas
            metadata=client.V1ObjectMeta(
                labels={"app": "my-flask-app"}
            ),
            # La especificación del pod, incluyendo los contenedores
            spec=client.V1PodSpec(
                containers=[
                    # El contenedor que se utilizará en el pod
                    client.V1Container(
                        # El nombre y la imagen del contenedor
                        name="my-flask-container",
                        image="image",
                        # Los puertos que el contenedor expone
                        ports=[client.V1ContainerPort(container_port=5000)]
                    )
                ]
            )
        )
    )
)

# Crear una instancia de la API de Kubernetes que puede manejar las operaciones de despliegue
api_instance = client.AppsV1Api(api_client)
# Crear el despliegue en el espacio de nombres predeterminado
api_instance.create_namespaced_deployment(
    namespace="default",
    body=deployment
)

# Definir un objeto de servicio que describe cómo exponer la aplicación
service = client.V1Service(
    # Metadata del servicio, incluyendo el nombre
    metadata=client.V1ObjectMeta(name="my-flask-service"),
    spec=client.V1ServiceSpec(
        # El selector para encontrar los pods que el servicio debe exponer
        selector={"app": "my-flask-app"},
        # Los puertos que el servicio expone
        ports=[client.V1ServicePort(port=5000)]
    )
)

# Crear una instancia de la API de Kubernetes que puede manejar las operaciones de servicio
api_instance = client.CoreV1Api(api_client)
# Crear el servicio en el espacio de nombres predeterminado
api_instance.create_namespaced_service(
    namespace="default",
    body=service
)
