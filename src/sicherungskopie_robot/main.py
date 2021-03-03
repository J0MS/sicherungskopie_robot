from sicherungskopie_robot.config import AppCommands, parse_args

def main():
    # load_dotenv()

    args = parse_args()

    # forecast_parameters_execution_id = (uuid4(),)

    # logging.basicConfig(level="DEBUG" if args.debug else "INFO")

    # logging.info(f"Command: {args.command}")

    if args.command == AppCommands.RESTORE:
        print(args)
        print('Restore')
        return


# print('From main')
