import React from 'react';
import {withRouter, RouteComponentProps} from "react-router-dom";
import { IEPage, IEPageField, IEPageAction, IETabbedFields } from '../../../model/epage';
import Loading from '../../loading';
import IErrors from '../../../model/errors';
import EditField from "../../edit-field";
import ValidationError from "../../validation-error";
import { IEPageService, IEPageGetResult, IEntityGetResult, IActionResult } from '../../../service/epage';
import Service from '../../../service';
import {CancelTokenSource} from "axios";
import {withLanguageListener, ILanguageProps } from '../../with-language-listener/with-language-listener';
import { ILanguageInfo } from '../../../model/language';
import FlowchartEdit from '../../flowchart/edit';
import IFlowchart from '../../../model/flowchart';
import "./intedit.css";
import { IBlockTemplate } from '../../../model/flowchart/template';

interface IProps extends RouteComponentProps, ILanguageProps {
    epageid: string;
    entityid?: string;
}

interface IState {
    epage?: IEPage;
    isLoading: boolean;
    entity?: any;
    errors: IErrors,
    touched: boolean;
    language?: ILanguageInfo;
}

class EPageIntEditInternal extends React.Component<IProps, IState> {


    private svc: IEPageService;
    private epageGetCancel?: CancelTokenSource;
    private entityGetCancel?: CancelTokenSource;
    private pageActionCancel?: CancelTokenSource;


    constructor(props: IProps) {
        super(props);
        console.log("EPageIntEdit - constructor");

        this.svc = Service.epage();

        this.state = {
            isLoading: false,
            errors: {},
            touched: false
        };
    }

    public static getDerivedStateFromProps(props: IProps, state: IState) {
        return {
            language: props.language
        };
    }

    protected startLoading() {
        this.setState({
            isLoading: true
        });
    }

    protected stopLoading() {
        this.setState({
            isLoading: true
        });
    }

    public componentDidMount() {
        const epageid = this.props.epageid;
        console.log("EPageIntEdit - componentDidMount epageid="+epageid);
        this.startLoading();
        const cancellablePromise = this.svc.epageGet(epageid);
        cancellablePromise.promise
            .then( (res) => this.epageGetCallback(res) )
            .catch( (err) => this.serviceError(err) );
        if(this.epageGetCancel) {
            this.epageGetCancel.cancel();
        }
        this.epageGetCancel = cancellablePromise.cancelControl;
    }

    protected serviceError(err: any) {
        console.error("serviceError err=");
        console.dir(err);
        this.stopLoading();
    }

    protected epageGetCallback(res: IEPageGetResult) {
        const entityid = this.props.entityid;
        console.log("epageGetCallback res=");
        console.dir(res);
        if(res.result === "OK" && res.payload) {
            const epage = res.payload;
            if(entityid) {
                this.setState({ epage: {...epage} });
                const cancellablePromise = this.svc.entityGet(epage.id, entityid)
                cancellablePromise.promise
                                  .then( (res) => this.entityGetCallback(res) )
                                  .catch( (err: any) => this.serviceError(err) );
                if(this.entityGetCancel) {
                    this.entityGetCancel.cancel();
                }
                this.entityGetCancel = cancellablePromise.cancelControl;
            } else {
                console.log("epageGetCallback - entityid is blank - new entity - setting to defaults");
                this.setState({
                    isLoading: false,
                    epage: {...epage}
                });
            }
            return;
        }
        console.error("epageGetCallback - epage is blank");
        this.serviceError("Error");
    }

    protected entityGetCallback(res: IEntityGetResult) {
        console.log("entityGetCallback res=");
        console.dir(res);
        if(res && res.result === "OK" && res.payload) {
            this.setState({
                isLoading: false,
                entity: res.payload
            });
            return;
        }
        console.error("entityGetCallback payload is blank");
        this.serviceError("Error");
    }

    protected onFlowChange(name: string, val: IFlowchart) {
       this.setChanged(name, val);
    }

    protected formatField(f: IEPageField) {
        const epage = this.state.epage;
        let epageid = "";
        if(epage) {
            epageid = epage.id;
        }
        const key = epageid + "_" + f.name;
        let value;
        const entity = this.state.entity;
        let error = "";
        if(entity) {
            value = entity[f.name];
        }
        error = this.state.errors[f.name];
        const type = f.type || "text";
        // console.log("formatField key="+key+" label="+f.label+" name="+f.name+" value="+value+" error="+error+" type="+type);
        // console.dir(this.state.errors);
        const grp = (epage?.entity+"_edit").toLowerCase();
        let fldname = ("fieldname_"+f.name).toLowerCase()
        const localizedLabel = this.props.localization.getLocalization(grp, fldname) || f.label;
        let localizedError = error;
        const tmp1 = this.props.localization.getLocalization(grp, error);
        if(tmp1 && tmp1.length>0) {
            localizedError = tmp1;
        }

        let fld = null;
        if(type==='flowchart') {
            //temporarily:
            /*
            const templates = [ BlockUtil.template0("Menu"),
                                BlockUtil.template0("Schedule"),
                                BlockUtil.template0("condition")
                              ];
            */
            let templates: IBlockTemplate[] = [];
            if(epage !== undefined && f.queryTag !== undefined) {
                templates = epage.lists[f.queryTag] || [];
            }
            fld = (
                <FlowchartEdit key={key} label={localizedLabel} name={f.name}
                   value={value} error={localizedError} templates={templates}
                   onFlowChange={ (val) => this.onFlowChange(f.name, val) }
                />
            );
        } else {
            //to prevent from warning about changing from uncontrolled to controlled input
            if(value===undefined) {
                value = "";
            }
            fld = (
                <EditField key={key} label={localizedLabel} name={f.name} value={value}
                   type={type}
                   error={localizedError}
                   onChange={ (e) => this.onChange(e) }
                />
            );
        }
        return fld;

    }

    protected onChange(e: React.ChangeEvent<HTMLInputElement>) {
        const name = e.target.name;
        const value = e.target.value;
        return this.setChanged(name, value);
    }

    protected setChanged(name: string, value: any) {

        const entity = {...(this.state.entity || {}) };
        const errors = {...this.state.errors};
        entity[name] = value;
        delete errors[name];
        this.setState({entity, errors, touched: false});
    }
    protected onSubmit(e: React.FormEvent<HTMLFormElement>) {
        e.preventDefault();
    }

    protected formatAction(a: IEPageAction) {
        const key = a.name;
        const grp = (this.state.epage?.entity+"_edit").toLowerCase();
        const lbl = ("buttonlabel_"+a.label).toLowerCase();
        const localizedLabel = this.props.localization.getLocalization(grp, lbl) || a.label;
        return (
            <React.Fragment key={key}>
               <button type="button" className="btn btn-primary"
                   onClick={ () => this.onAction(a)}>{localizedLabel}
               </button>
               &nbsp;
            </React.Fragment>
        );
    }

    protected onAction(a: IEPageAction) {
        console.log("onAction a=");
        console.dir(a);
        const entity = this.state.entity || {};
        console.log("entity=");
        console.log(entity);
        this.startLoading();
        const cancellablePromise = this.svc.entityAction(a.id, entity);
        cancellablePromise.promise
                          .then( (res) => this.actionCallback(res) )
                          .catch( (err) => this.actionErrors(err) );
        if(this.pageActionCancel) {
            this.pageActionCancel.cancel();
        }
        this.pageActionCancel = cancellablePromise.cancelControl;
    }

    protected actionCallback(res: IActionResult) {
        console.log("actionCallback res=");
        console.dir(res);
        if(res && res.result === "OK" && res.payload) {
            if(res.payload.nextpage) {
                const url = res.payload.nextpage;
                console.log("actionCallback redirecting to "+url);
                this.props.history.push(url);
                return;
            }
            console.log("nextpage is blank - doing nothing");
            this.stopLoading();
        }
        if(res.errors) {
            return this.actionErrors(res);
        }
        console.error("actionCallback payload is blank and errors are blank")
        this.serviceError("Error");
    }

    protected actionErrors(res: any) {
        console.log("actionErrors - res=");
        console.dir(res);
        if(res.errors) {
            return this.setState({
                                   isLoading: false,
                                   errors: {...res.errors}
            });
        }
        console.log("actionErrors - errors is blank, dont know what to do");
        this.stopLoading();
    }

    public componentWillUnmount() {
        if(this.epageGetCancel) {
            this.epageGetCancel.cancel();
        }
        if(this.entityGetCancel) {
            this.entityGetCancel.cancel();
        }
        if(this.pageActionCancel) {
            this.pageActionCancel.cancel();
        }
    }

    protected addTabField(tabs: IETabbedFields, fi: IEPageField) {
        let tab = fi.tab;
        if(tab!==undefined && tab.length>0) {
            const tabfields = tabs[tab] || [];
            tabfields.push(fi);
            tabs[tab] = tabfields;
        }
    }

    protected formatTabs(tab: string, tabIndex: number) {
        const href = "#"+tab+"-tab";
        const label = tab;
        const className=(tabIndex===0) ? "nav-link active" : "nav-link";
        return (
           <li className={className} key={tab}>
               <a data-toggle="tab" href={href}>
                    {label}
               </a>
           </li>
        );
    }

    protected formatTabFields(tab: string, tabIndex: number, fields: IEPageField[]) {
        const id=tab+"-tab";
        const className=(tabIndex===0) ? "tab-pane fade in fieldstab active" : "tab-pane fade in fieldstab";
        return (
            <div className={className} id={id} key={id}>
                {fields.map( (fi) => this.formatField(fi))}
            </div>
        );
    }

    public render() {
        console.log("EPageIntEdit render");
        if(this.state.isLoading) {
            return <Loading />;
        }
        if(!this.state.epage) {
            return <Loading />;
        }

        const epage = this.state.epage;
        const fields = epage.fields;
        const error = this.state.errors.error;
        const actions = epage.pageactions;

        const grp = (this.state.epage.entity).toLowerCase();
        const header = epage.label.toLowerCase();
        const localizedHeader = this.props.localization.getLocalization(grp, header) || epage.label || "Edit";

        const tabs: IETabbedFields = {};
        fields.forEach( (fi) => this.addTabField(tabs, fi));

        console.log("000000000 tabs=");
        console.dir(tabs);

        let renderedFields = null;
        let tabHeads = null;
        if ( Object.keys(tabs).length === 0  ) {
            renderedFields = fields.map( (f)=> this.formatField(f));
            console.log("tabs is blank , renderedFields=");
            console.dir(renderedFields);
        } else {
            tabHeads =  (
               <ul className="nav nav-tabs">
                  { Object.keys(tabs).map( (t, ndx) => this.formatTabs(t, ndx) ) }
               </ul>
            );
            renderedFields = (
                <div className="tab-content clearfix">
                     { Object.keys(tabs).map( (t, ndx) => this.formatTabFields(t, ndx, tabs[t]) ) }
                </div>
            );
        }
        const ta: JSX.Element[] = [];
        actions.forEach( (a) => a.location === 'top' && ta.push(this.formatAction(a)) );
        let topActions = null;
        if(ta.length>0) {
            topActions = (
                <div className="form-group-control action-group">
                    {ta}
                </div>
            );
        }

        const ba: JSX.Element[] = [];
        actions.forEach( (a) => a.location !== 'top' && ba.push(this.formatAction(a)) );
        let bottomActions = null;
        if(ba.length>0) {
            console.log("9999999999999ba = ");
            console.dir(ba);
            bottomActions = (
                <div className="form-group-control action-group">
                    {ba}
                </div>
            );
        }

        console.log("888888888 ba=");
        console.dir(ba);
        console.log("bottomActions=");
        console.dir(bottomActions);


        return (
        <React.Fragment>
            <div className="container">
                <h2>{localizedHeader}</h2>
            </div>

            <div className="container">
               <form onSubmit={ (e:React.FormEvent<HTMLFormElement>) =>
                                         this.onSubmit(e)
                               }
                >
                    {topActions}
                    <br/>
                    {tabHeads}
                    {renderedFields}
                    <div className="validation-error">
                        <ValidationError name="error" error={error} />
                    </div>
                    <br/>
                    {bottomActions}
                </form>
            </div>
        </React.Fragment>
        );
    }
}

const tmp = withLanguageListener(EPageIntEditInternal);
const EPageIntEdit = withRouter(tmp);

export default EPageIntEdit;

