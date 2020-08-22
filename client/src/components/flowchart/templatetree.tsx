import React from "react";
import "./template-tree.css";
import { IBlockTemplate } from "../../model/flowchart/template";

interface IProps {
    templates: IBlockTemplate[];
}

class TemplateTreeInternal extends React.Component<IProps> {

    protected dragStart(e: React.DragEvent) {
        e.persist();
        console.log("drag start");
        console.dir(e.target);
        let id = (e.target as any).id || "";
        e.dataTransfer.setData("Text", id);
    }

    protected renderTemplate(t: IBlockTemplate) {
        return (
            <li key={t.name} onDragStart = {(e) => this.dragStart(e)}>
                <span className="template-span">
                    <i className="far fa-file"></i>
                    <a className="draggable" id={t.label} href="/#">{t.label} </a>
                </span>
            </li>
        );
    }

    public render() {

        return (
                <div className="tree">
                    <h3> Block Templates </h3>
                    <ul>
                        <li>
                            <span>
                                <a className="templatetree-a1" data-toggle="collapse"
                                   href="#All" aria-expanded="true" aria-controls="All"
                                >
                                    <i className="collapsed">
                                        <i className="fas fa-folder"></i>
                                    </i>
                                    <i className="expanded">
                                        <i className="far fa-folder-open"></i>
                                    </i> Templates
                                </a>
                            </span>
                            <div id="All" className="collapse show">
                                <ul>
                                    {this.props.templates.map( (t) => this.renderTemplate(t))}
                                </ul>
                            </div>
                        </li>
                    </ul>
                </div>
        );
    }
}

const TemplateTree = TemplateTreeInternal;
export default TemplateTree;
