import {
    BaseEntity,
    Column,
    CreateDateColumn,
    Entity,
    OneToMany,
    OneToOne,
    PrimaryGeneratedColumn,
    UpdateDateColumn
} from "typeorm";
import {Order} from "./order.schema";
import {ReturnItem} from "./return_item.schema";


@Entity('tbl_return')
export class Return extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @OneToOne(() => Order, (order) => order.returnRecord, { nullable: false })
    order: Order;

    @OneToMany(() => ReturnItem, (returnItem) => returnItem.returnRecord,{ nullable: true })
    returnItems: ReturnItem[];

    @Column({type: 'text', nullable: true})
    returnReason: string;

    @Column()
    returnDate: Date;

    @Column()
    createdBy: string;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn({nullable: true})
    updatedAt: Date;
}
