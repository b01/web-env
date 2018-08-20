while test $# -gt 0; do
        case "$1" in
                -h|--help)
                        echo "$package - attempt to start WebEnv"
                        echo " "
                        echo "$package [options] [arguments]"
                        echo " "
                        echo "options:"
                        echo "-h, --help                show brief help"
                        echo "-c, --cname=Container     specify a container to mirror ssh keys and git config"
                        echo "-f                        specify a docker compose configuration file"
                        exit 0
                        ;;
                -c)
                        shift
                        if test $# -gt 0; then
                                export cname=$1
                        else
                                echo "no container name specified"
                                exit 1
                        fi
                        shift
                        ;;
                --cname*)
                        export cname=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                -f)
                        shift
                        if test $# -gt 0; then
                                export dcFile=$1
                        else
                                echo "no docker composer configuration file specified"
                                exit 1
                        fi
                        shift
                        ;;
                -n)
                        shift
                        if test $# -gt 0; then
                                export iaterm=$1
                        else
                                echo "no container name specified"
                                exit 1
                        fi
                        shift
                        ;;
                -w)
                        shift
                        if test $# -gt 0; then
                                export nWin=$1
                        else
                                echo "no container name specified"
                                exit 1
                        fi
                        shift
                        ;;
                *)
                        break
                        ;;
        esac
done