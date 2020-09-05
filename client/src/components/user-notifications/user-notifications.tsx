import React from "react";
import "./user-notifications.css";
//import 'bootstrap/dist/css/bootstrap.min.css';
import "font-awesome/css/font-awesome.css";
import "font-awesome/fonts/fontawesome-webfont.woff2";

interface IProps {
}

interface IState {
}

class UserNotificationsInternal extends React.Component<IProps, IState> {
    public render() {
         return (
            <li>
                <a>                    
                    <span data-toggle="dropdown" title="Notifications" 
                        className="notification-btn-base icon-base">
                        <i className="fa fa-bell notification-btn "></i>
                            <span className="unread-red-circle">10</span>
                    </span>
                </a>
            </li>

         );
    }
}

const UserNotifications = UserNotificationsInternal;
export default UserNotifications;