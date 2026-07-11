import { InnerPage } from 'components'
import { Layout } from 'config'
import { useDB, useUser } from 'hooks'

const $1 = () => {
  const jots = useDB('jot')
  const { user, settings } = useUser()
  if (!user) return null

  return (
    <Layout>
      <InnerPage>
        $2
      </InnerPage>
    </Layout>
  )
}

export default $1
