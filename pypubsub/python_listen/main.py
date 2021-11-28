import asfpy.pubsub


def process_event(payload):
    print('===========================')
    print("we got an event from pubsub")
    print(payload)


def main():
    pubsub = asfpy.pubsub.Listener('http://localhost:2069')
    pubsub.attach(process_event, raw=True)  # poll forever


main()
