import React from "react";
import Service from "../../service";
import "./action-buttons.css";
import { IEPageAction } from "../../model/epage";

interface IProps {
    action: IEPageAction    
    parent: string;
    onAction: (action: IEPageAction) => void;
}

const TopActionButton: React.FC<IProps> = (props: IProps) => {
    const {action, onAction, parent} = props;
    const local = Service.localization().local(parent);    
    const label = local(`${parent}_${action.name}_label`) || action.label;
    const classes = local(`${parent}_${action.name}_class`) || "";
    const iconpath = local(`${parent}_${action.name}_icon`);
    const key = action.id;
    let im;
    if(iconpath) {
        im = (<img src={iconpath} className="top-action-button"></img>);
    }
    return (
        <button key={key} className={classes} onClick = { () => onAction(action) }>
            {im} &nbsp;  {label}
        </button>
    );
}

export default TopActionButton;


            
        
