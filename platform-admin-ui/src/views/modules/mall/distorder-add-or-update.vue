<template>
  <el-dialog
    title="查看"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form inline :model="dataForm" label-width="80px">
      <el-form-item label="会员昵称" prop="nickname">
        <el-input v-model="dataForm.nickname" disabled placeholder="会员昵称"></el-input>
      </el-form-item>
      <el-form-item label="购买者" prop="buyerNickname">
        <el-input v-model="dataForm.buyerNickname" disabled placeholder="购买者"></el-input>
      </el-form-item>
      <el-form-item label="订单编号" prop="orderSn">
        <el-input v-model="dataForm.orderSn" disabled placeholder="订单编号"></el-input>
      </el-form-item>
      <el-form-item label="订单类型" prop="type">
        <el-select v-model="dataForm.type" disabled placeholder="订单类型" clearable>
          <el-option v-for="item in orderTypes" :key="item.value" :label="item.label" :value="item.value"/>
        </el-select>
      </el-form-item>
      <el-form-item label="结算收益" prop="income">
        <el-input v-model="dataForm.income" disabled placeholder="结算收益"></el-input>
      </el-form-item>
      <el-form-item label="结算时间" prop="incomeTime">
        <el-date-picker v-model="dataForm.incomeTime" type="datetime" disabled
                        placeholder="结算时间"></el-date-picker>
      </el-form-item>
      <el-form-item label="分销级数" prop="level">
        <el-input v-model="dataForm.level" disabled placeholder="分销级数"></el-input>
      </el-form-item>
      <el-form-item label="企业付款单号" prop="paymentNo">
        <el-input v-model="dataForm.paymentNo" disabled placeholder="企业付款单号"></el-input>
      </el-form-item>
      <el-form-item label="是否已审核" prop="isAudit">
        <el-checkbox v-model="dataForm.isAudit" disabled placeholder="是否审核中"></el-checkbox>
      </el-form-item>
    </el-form>
    <span slot="footer" class="dialog-footer">
      <el-button @click="visible = false">取消</el-button>
    </span>
  </el-dialog>
</template>

<script>
export default {
  props: ['orderTypes'],
  data () {
    return {
      visible: false,
      dataForm: {
        id: '',
        userId: '',
        subUserId: '',
        nickname: '',
        buyerNickname: '',
        orderId: '',
        orderSn: '',
        type: '',
        income: '',
        incomeTime: '',
        level: '',
        paymentNo: '',
        isAudit: ''
      }
    }
  },
  methods: {
    init (id) {
      this.dataForm.id = id || ''
      this.visible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].resetFields()
        if (this.dataForm.id) {
          this.$http({
            url: `/mall/distorder/info/${this.dataForm.id}`,
            method: 'get'
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.dataForm = data.distorder
            }
          })
        }
      })
    }
  }
}
</script>
