import React from 'react';
import {withRouter, RouteComponentProps } from "react-router-dom";
import {IMenuService, IMenuListResult} from "../../service/menu";

import Service from "../../service";
import IMenu from "../../model/menu";
import "./menu.css";
import { CancelTokenSource } from "axios";
import { ILanguageProps } from "../with-language-listener";
import { ILanguageInfo } from "../../model/language";
import { withLanguageListener } from "../with-language-listener";
import { INotificationService } from "../../service/notification";
import {withUniqueId, IUniqueId} from "../uniqueid";
import { ILocalizationLocal } from "../../service/localization";
 
interface IProps extends RouteComponentProps, ILanguageProps, IUniqueId {
    name: string;
}

interface IState {
    isLoading: boolean;
    menulist: IMenu[];
    language?: ILanguageInfo;
}

class MenuInternal extends React.Component<IProps, IState> {
    private menuSvc: IMenuService;
    private notificationSvc: INotificationService;
    private menuListCancel?: CancelTokenSource;
    private local: ILocalizationLocal;

    constructor(props: IProps) {
        super(props);
        this.menuSvc  = Service.menu();
        this.notificationSvc = Service.notification();
        this.state = {
            isLoading: false,
            menulist: []
        };
        const localizationKey = "menu_"+props.name;
        this.local = Service.localization().local(localizationKey);
    }

    public componentDidMount() {
        this.refresh();
    }

    protected refresh() {
        this.startLoading();
        const name = this.props.name;
        if(name && name.length>0) {
            if(this.menuListCancel) {
                this.menuListCancel.cancel();
                this.menuListCancel=undefined;
            }
            const cancellablePromise = this.menuSvc.menuList(name);
            cancellablePromise.promise
                              .then( (res: IMenuListResult) => this.serviceListCallback(res))
                              .catch( (err: any) => this.serviceListError(err));
            this.menuListCancel = cancellablePromise.cancelControl;
        }
    }
     
    protected startLoading() {
        this.setState({
            isLoading: true
        });
    }
    protected stopLoading() {
        this.setState({
            isLoading: false
        });
    }

    protected serviceListCallback(res: IMenuListResult) {
        if(res.result === "OK") {
            this.setState({isLoading: false, menulist: res.payload});
            if(res.payload) {
                this.notificationSvc.register(this.props.name,
                                              this.props.uniqueid,
                                              () => this.refresh()
                                             );
            }
            return;
        }
        this.serviceListError("Error");
    }

    public componentWillUnmount() {
        console.log("Menu - componentWillUnmount");
        if(this.menuListCancel) {
            this.menuListCancel.cancel();
        }
    }

    serviceListError(err: any) {
        this.stopLoading();
        console.log("serviceGetError err=");
        console.dir(err);
    }

    protected onMenu(e: React.MouseEvent<HTMLAnchorElement>, m: IMenu) {
        console.log("onMenu m=");
        console.dir(m)
        e.preventDefault();
        let url = m.url;
        const epage_id = m.epage_id;
        if(epage_id) {
            url = "/epage/"+epage_id+"/list";
        }
        console.log("onMenu redirecting to "+url);        
        if(url) {
            this.props.history.push(url);
        } else {
            console.error("url is blank");
        }
    }

    

    protected formatMenu(m: IMenu) {
        const label = this.local(m.name) || m.name;
        const key=`${m.name}_${m.id}`;
        if(m.items && m.items.length>0) {                        
            return (
                <li className="dropdown nav-item" key={key}>
                    <a href="/#" className="dropdown-toggle" data-toggle="dropdown"
                        role="button" aria-haspopup="true" aria-expanded="false"
                    >
                        {label}
                        <span className="caret"></span>
                    </a>
                    <ul className="dropdown-menu">
                        {m.items.map( (mi: IMenu) => this.formatMenuItem(mi))}
                    </ul>
                </li>
            );
        }
        return (
            <li className="nav-item" key={key}>
                <a href="/#" onClick={(e: React.MouseEvent<HTMLAnchorElement>) => this.onMenu(e, m)}>{label}</a>
            </li>
        );
    }

    protected formatMenuItem(m: IMenu) {
        const label = this.local(m.name) || m.name;
        const key=`${m.name}_${m.id}`;
        return (
            <li key={key}>
               <a href="/#" onClick={(e: React.MouseEvent<HTMLAnchorElement>) =>
                         this.onMenu(e, m) }
               >
                   {label}
               </a>
            </li>
        );
    }

    
    public render() {
        const menulist = this.state.menulist;
        return (
            <ul className="nav navbar-nav">
                {menulist.map( (p: IMenu) => this.formatMenu(p) )}
            </ul>
        );
    }
}

const tmp = withLanguageListener(MenuInternal)
const tmp2 = withUniqueId(tmp);
const Menu = withRouter(tmp2);

export default Menu;
