import React from 'react';
import Service from "../../service";
import {ILocalizationService, ILocalizationLocal} from "../../service/localization";
import {withLanguageListener, ILanguageProps } from '../with-language-listener';
import { ILanguageInfo } from '../../model/language';

interface IProps extends ILanguageProps {
    localizationKey: string;
    msgkey: string;
    defaultMsg: string;
}

interface IState {
    language?: ILanguageInfo;
}

class SimplePageInternal extends React.Component<IProps, IState> {
    localizationSvc: ILocalizationService;
    local: ILocalizationLocal;


    public static getDerivedStateFromProps(props: IProps, state: IState) {
        return {
            language: props.language
        };
    }

    constructor(props: IProps) {
        super(props);
        this.localizationSvc = Service.localization();
        this.local = this.localizationSvc.local(props.localizationKey);

        this.state = {
            language: props.language
        };
    }

    public render() {
        const msg = this.local(this.props.msgkey) || this.props.defaultMsg;
        return (
           <div>
              {msg}
          </div>
        );
    }
}

const Landing = withLanguageListener(SimplePageInternal);
export default Landing;
