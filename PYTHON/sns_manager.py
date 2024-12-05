import configparser
import boto3
import os
import argparse
import pandas as pd

def get_credentials(profile_name):
    session = boto3.Session(profile_name=profile_name)
    credentials = session.get_credentials()
    return credentials.get_frozen_credentials()

def list_sns(sns_client, profile_name, region, data):
    response = sns_client.list_topics()
    for topic in response['Topics']:
        topic_arn = topic['TopicArn']
        print(f"Tópico encontrado en el perfil {profile_name}: {topic_arn}")

        subscriptions = sns_client.list_subscriptions_by_topic(TopicArn=topic_arn)
        for subscription in subscriptions['Subscriptions']:
            protocol = subscription['Protocol']
            endpoint = subscription['Endpoint']
            print(f"  Suscripción: {protocol} - {endpoint}")

            data.append({
                'Perfil': profile_name,
                'Región': region,
                'TopicArn': topic_arn,
                'Protocolo': protocol,
                'Endpoint': endpoint
            })

def manage_suscription(sns_client, topic_arn, endpoint, protocol, action):
    subscriptions = sns_client.list_subscriptions_by_topic(TopicArn=topic_arn)
    subscription_exists = False
    subscription_arn = None

    for subscription in subscriptions['Subscriptions']:
        if subscription['Protocol'] == protocol and subscription['Endpoint'] == endpoint:
            subscription_exists = True
            subscription_arn = subscription['SubscriptionArn']
            break

    if action == 'create':
        if not subscription_exists:
            sns_client.subscribe(
                TopicArn=topic_arn,
                Protocol=protocol,
                Endpoint=endpoint
            )
            print(f"Suscripción {protocol.upper()} creada para el tópico {topic_arn}")
        else:
            print(f"Ya existe una suscripción {protocol.upper()} para el tópico {topic_arn}")
    elif action == 'delete':
        if subscription_exists:
            sns_client.unsubscribe(SubscriptionArn=subscription_arn)
            print(f"Suscripción {protocol.upper()} eliminada para el tópico {topic_arn}")
        else:
            print(f"No se encontró una suscripción {protocol.upper()} para el tópico {topic_arn} con el endpoint {endpoint}")

def main():
    parser = argparse.ArgumentParser(description='Gestionar suscripciones SNS.')
    parser.add_argument('--action', choices=['create', 'delete', 'list'], required=True, help='Acción a realizar: create, delete o list')
    parser.add_argument('--topic', help='Tópico SNS a gestionar (use "all" para todos los tópicos)')
    parser.add_argument('--endpoint', help='Endpoint de la suscripción')
    parser.add_argument('--protocol', choices=['https', 'email'], help='Protocolo de la suscripción (https o email)')
    args = parser.parse_args()

    config_file = os.path.expanduser('~/.aws/config')
    config = configparser.ConfigParser()
    config.read(config_file)

    data = []

    for profile in config.sections():
        if profile.startswith('profile '):
            profile_name = profile.replace('profile ', '')
            region = config[profile]['region']
            print(f"Procesando perfil: {profile_name}, Región: {region}")

            credentials = get_credentials(profile_name)
            sns_client = boto3.client(
                'sns',
                aws_access_key_id=credentials.access_key,
                aws_secret_access_key=credentials.secret_key,
                aws_session_token=credentials.token,
                region_name=region
            )

            if args.action == 'list':
                list_sns(sns_client, profile_name, region, data)
            else:
                if not args.endpoint or not args.protocol:
                    print("Debe proporcionar el endpoint y el protocolo para las acciones create y delete.")
                    continue

                if args.topic == 'all':
                    response = sns_client.list_topics()
                    for topic in response['Topics']:
                        topic_arn = topic['TopicArn']
                        manage_suscription(sns_client, topic_arn, args.endpoint, args.protocol, args.action)
                else:
                    response = sns_client.list_topics()
                    topic_arn = None
                    for topic in response['Topics']:
                        if args.topic in topic['TopicArn']:
                            topic_arn = topic['TopicArn']
                            break

                    if topic_arn:
                        print(f"Tópico encontrado en el perfil {profile_name}: {topic_arn}")
                        manage_suscription(sns_client, topic_arn, args.endpoint, args.protocol, args.action)
                    else:
                        print(f"No se encontró el tópico {args.topic} en el perfil {profile_name}")

    if args.action == 'list':
        # Crear un DataFrame de pandas con los datos recopilados
        df = pd.DataFrame(data)

        # Guardar el DataFrame en un archivo Excel
        df.to_excel('sns_topics_subscriptions.xlsx', index=False)

        print("La información se ha guardado en el archivo sns_topics_subscriptions.xlsx")

if __name__ == "__main__":
    main()
