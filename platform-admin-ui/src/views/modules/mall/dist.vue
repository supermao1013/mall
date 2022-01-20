<template>
  <div class="mod-dist">
    <el-form :inline="true" :model="searchForm" @keyup.enter.native="getDataList(1)">
      <el-form-item>
        <el-input v-model="searchForm.nickname" placeholder="会员昵称" clearable></el-input>
      </el-form-item>
      <el-form-item>
        <el-button @click="getDataList(1)">查询</el-button>
        <el-button v-if="isAuth('mall:dist:delete')" type="danger" @click="deleteHandle()"
                   :disabled="dataListSelections.length <= 0">批量删除
        </el-button>
      </el-form-item>
    </el-form>
    <el-table
      :data="dataList"
      border
      @selection-change="selectionChangeHandle"
      style="width: 100%;">
      <el-table-column
        type="selection"
        header-align="center"
        align="center"
        width="50">
      </el-table-column>
      <el-table-column
        prop="nickname"
        header-align="center"
        align="center"
        label="会员昵称">
      </el-table-column>
      <el-table-column
        prop="superiorNickname"
        header-align="center"
        align="center"
        label="上级分销">
      </el-table-column>
      <el-table-column
        prop="isAudit"
        header-align="center"
        align="center"
        label="审核状态">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.isAudit" size="small" type="success">已审核</el-tag>
          <template v-else>
            <el-tag size="small" type="danger">待审核</el-tag>
            <el-button v-if="isAuth('mall:dist:confirmAudit')" type="primary" size="mini"
                       @click="confirmAudit(scope.row.id)">
              审核通过
            </el-button>
          </template>
        </template>
      </el-table-column>
      <el-table-column
        prop="joinTime"
        header-align="center"
        align="center"
        label="加入时间">
      </el-table-column>
      <el-table-column
        prop="amountAvailable"
        header-align="center"
        align="center"
        label="待取佣金">
      </el-table-column>
      <el-table-column
        prop="amountWithdrawn"
        header-align="center"
        align="center"
        label="已取佣金">
      </el-table-column>
      <el-table-column
        prop="amountTotal"
        header-align="center"
        align="center"
        label="累计佣金">
      </el-table-column>
      <el-table-column
        prop="invitationCode"
        header-align="center"
        align="center"
        label="邀请码">
      </el-table-column>
      <el-table-column
        fixed="right"
        header-align="center"
        align="center"
        width="150"
        label="操作">
        <template slot-scope="scope">
          <el-button v-if="isAuth('mall:dist:info')" type="text" size="small" @click="showDetails(scope.row.id)">查看
          </el-button>
          <el-button v-if="isAuth('mall:dist:update')" type="text" size="small"
                     @click="addOrUpdateHandle(scope.row.id)">修改
          </el-button>
          <el-button v-if="isAuth('mall:dist:delete')" type="text" size="small" @click="deleteHandle(scope.row.id)">删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      @size-change="sizeChangeHandle"
      @current-change="currentChangeHandle"
      :current-page="pageIndex"
      :page-sizes="[10, 20, 50, 100]"
      :page-size="pageSize"
      :total="totalPage"
      layout="total, sizes, prev, pager, next, jumper">
    </el-pagination>
    <!-- 弹窗, 新增 / 修改 -->
    <add-or-update v-if="addOrUpdateVisible" ref="addOrUpdate" @refreshDataList="getDataList"></add-or-update>
  </div>
</template>

<script>
import AddOrUpdate from './dist-add-or-update'

export default {
  data () {
    return {
      searchForm: {
        nickname: null
      },
      dataList: [],
      pageIndex: 1,
      pageSize: 10,
      totalPage: 0,
      dataListSelections: [],
      addOrUpdateVisible: false
    }
  },
  components: {
    AddOrUpdate
  },
  activated () {
    this.getDataList()
  },
  methods: {
    // 获取数据列表
    getDataList (page) {
      if (page) {
        this.pageIndex = page
      }
      this.$http({
        url: '/mall/dist/list',
        method: 'get',
        params: {
          'page': this.pageIndex,
          'limit': this.pageSize,
          'nickname': this.searchForm.nickname
        }
      }).then(({data}) => {
        if (data && data.code === 0) {
          this.dataList = data.page.records
          this.totalPage = data.page.total
        } else {
          this.dataList = []
          this.totalPage = 0
        }
      })
    },
    // 每页数
    sizeChangeHandle (val) {
      this.pageSize = val
      this.pageIndex = 1
      this.getDataList()
    },
    // 当前页
    currentChangeHandle (val) {
      this.pageIndex = val
      this.getDataList()
    },
    // 多选
    selectionChangeHandle (val) {
      this.dataListSelections = val
    },
    // 查看详情
    showDetails (id) {
      this.addOrUpdateVisible = true
      this.$nextTick(() => {
        this.$refs.addOrUpdate.init(id, true)
      })
    },
    // 新增 / 修改
    addOrUpdateHandle (id) {
      this.addOrUpdateVisible = true
      this.$nextTick(() => {
        this.$refs.addOrUpdate.init(id)
      })
    },
    // 删除
    deleteHandle (id) {
      let ids = id ? [id] : this.dataListSelections.map(item => {
        return item.id
      })
      this.$confirm('确定对所选项进行[删除]操作?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http({
          url: '/mall/dist/delete',
          method: 'post',
          data: ids
        }).then(({data}) => {
          if (data && data.code === 0) {
            this.$message({
              message: '操作成功',
              type: 'success',
              duration: 1500
            })
            this.getDataList()
          }
        })
      }).catch(() => {
      })
    },
    // 分销商申请审核通过
    confirmAudit (id) {
      this.$http({
        url: `/mall/dist/confirmAudit/${id}`,
        method: 'post'
      }).then(({data}) => {
        if (data && data.code === 0) {
          this.$message({
            message: '操作成功',
            type: 'success',
            duration: 1500
          })
          this.getDataList()
        }
      })
    }
  }
}
</script>
